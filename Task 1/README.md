# INSTRUCTIONS

## COMPETENCIES

4049.1.1 : Automating Administrative Tasks

The graduate writes scripts for both local and remote systems to automate administrative tasks.

## INTRODUCTION

In this task you will create PowerShell script. PowerShell enables administrators to perform administrative tasks on both local and remote systems. You will be expected to apply scripting standards and use exception and exit handling where appropriate. The completed product will prompt the user for input to complete various tasks until the user selects a prompt to exit the script.

For this task, you will use the Performance Assessment Lab Area accessed by the Performance Assessment Lab Area link to access the virtual lab environment to complete this task.

## SCENARIO

You are working as a server administrator at a consulting firm. Your client is a recent start-up company based out of Salt Lake City, Utah. Currently their environment contains only 35 employees. They will be doubling their staff in the coming months, and you will need to start automating some processes that are commonly run. In the near future, they may be hiring an intern for the system administration. As such, you will need to comment throughout the script to identify the script processes. Please follow the task requirements below to help this company.

## REQUIREMENTS

Your submission must be your original work. No more than a combined total of 30% of a submission can be directly quoted or closely paraphrased from sources, even if cited correctly. Use the report provided when submitting your task as a guide.

You must use the rubric to direct the creation of your submission because it provides detailed criteria that will be used to evaluate your work. Each requirement below may be evaluated by more than one rubric aspect. The rubric aspect titles may contain hyperlinks to relevant portions of the course.

A. Create a PowerShell script named “prompts.ps1” within the “Requirements1” folder. For the first line, create a comment and include your first and last name along with your student ID.

Note: The remainder of this task should be completed within the same script file, prompts.ps1.

B. Create a “switch” statement that continues to prompt a user by doing each of the following activities, until a user presses key 5:

1. Using a regular expression, list files within the Requirements1 folder, with the .log file extension and redirect the results to a new file called “DailyLog.txt” within the same directory without overwriting existing data. Each time the user selects this prompt, the current date should precede the listing. (User presses key 1.)

2. List the files inside the “Requirements1” folder in tabular format, sorted in ascending alphabetical order. Direct the output into a new file called “C916contents.txt” found in your “Requirements1” folder. (User presses key 2.)

3. List the current CPU and memory usage. (User presses key 3.)

4. List all the different running processes inside your system. Sort the output by virtual size used least to greatest, and display it in grid format. (User presses key 4.)

5. Exit the script execution. (User presses key 5.)

C. Apply scripting standards throughout your script, including the addition of comments that describe the behavior of each of parts B1–B5.

D. Apply exception handling using try-catch for System.OutOfMemoryException.

E. Run your script and take a screenshot of the user results when each prompt (parts B3–B4) is chosen. Save each screenshot within the “Requirements1” folder. Compress all files (original and new) within the folder to a ZIP archive.

F. When you are ready to submit your final script, run the Get-FileHash cmdlet against the “Requirements1” ZIP archive. Note that hash value and place it into the comment section when you submit your task.

### File Restrictions

File name may contain only letters, numbers, spaces, and these symbols: ! - _ . * ' ( )
File size limit: 200 MB
File types allowed: doc, docx, rtf, xls, xlsx, ppt, pptx, odt, pdf, txt, qt, mov, mpg, avi, mp3, wav, mp4, wma, flv, asf, mpeg, wmv, m4v, svg, tif, tiff, jpeg, jpg, gif, png, zip, rar, tar, 7z