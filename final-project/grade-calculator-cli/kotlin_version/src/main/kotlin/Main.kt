import org.apache.poi.ss.usermodel.WorkbookFactory
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import kotlin.system.exitProcess

fun main(args: Array<String>) {
    // Check arguments
    if (args.size != 2) {
        println("Usage: ./gradlew run --args=\"<input.xlsx> <output.xlsx>\"")
        println("Example: ./gradlew run --args=\"input.xlsx output.xlsx\"")
        exitProcess(1)
    }

    val inputFile = args[0]
    val outputFile = args[1]

    // Check if input file exists
    if (!File(inputFile).exists()) {
        println("Error: Input file \"$inputFile\" not found")
        exitProcess(1)
    }

    try {
        println("Reading input file: $inputFile")

        // Read input Excel file
        FileInputStream(inputFile).use { fis ->
            val workbook = WorkbookFactory.create(fis)
            val sheet = workbook.getSheetAt(0)

            // Process student data
            val results = mutableListOf<GradeResult>()
            var isFirstRow = true

            for (row in sheet) {
                // Skip header row
                if (isFirstRow) {
                    isFirstRow = false
                    continue
                }

                // Read name and marks
                if (row.physicalNumberOfCells >= 2) {
                    val nameCell = row.getCell(0)
                    val marksCell = row.getCell(1)

                    if (nameCell != null && marksCell != null) {
                        val name = nameCell.toString()
                        val marks = when {
                            marksCell.cellType.name == "NUMERIC" -> marksCell.numericCellValue.toInt()
                            else -> marksCell.toString().toIntOrNull() ?: 0
                        }

                        val result = GradeCalculator.processStudent(name, marks)
                        results.add(result)
                        println("Processed: ${result.name} - ${result.marks} marks -> ${result.grade} (GPA: ${result.gpa})")
                    }
                }
            }

            workbook.close()

            println("\nGenerating output file: $outputFile")

            // Create output Excel file
            val outputWorkbook = XSSFWorkbook()
            val outputSheet = outputWorkbook.createSheet("Sheet1")

            // Write header
            val headerRow = outputSheet.createRow(0)
            headerRow.createCell(0).setCellValue("Name")
            headerRow.createCell(1).setCellValue("Marks")
            headerRow.createCell(2).setCellValue("Grade")
            headerRow.createCell(3).setCellValue("GPA")

            // Write results
            results.forEachIndexed { index, result ->
                val dataRow = outputSheet.createRow(index + 1)
                dataRow.createCell(0).setCellValue(result.name)
                dataRow.createCell(1).setCellValue(result.marks.toDouble())
                dataRow.createCell(2).setCellValue(result.grade)
                dataRow.createCell(3).setCellValue(result.gpa)
            }

            // Auto-size columns
            for (i in 0..3) {
                outputSheet.autoSizeColumn(i)
            }

            // Save output file
            FileOutputStream(outputFile).use { fos ->
                outputWorkbook.write(fos)
            }

            outputWorkbook.close()

            println("Successfully processed ${results.size} student(s)")
            println("Output saved to: $outputFile")
        }

    } catch (e: Exception) {
        println("Error processing Excel file: ${e.message}")
        e.printStackTrace()
        exitProcess(1)
    }
}

