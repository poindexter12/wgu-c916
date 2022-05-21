# INSTRUCTIONS

## COMPETENCIES

4049.1.2 : Server Roles and Features

The graduate writes scripts to install and manage server roles and features.

## INTRODUCTION

In this task, you will create PowerShell script. PowerShell enables administrators to perform administrative tasks on both local and remote systems. You will be expected to manage an Active Directory server and an SQL server within the PowerShell environment. This management will include the configuration and administration of the servers.

For this task, you will use the Performance Assessment Lab Area accessed by the Performance Assessment Lab Area link to access the virtual lab environment to complete this task.

## SCENARIO

You have been hired as a consultant at a company. The company previously had an SQL server and Active Directory server configured throughout two separate Windows 2012 servers. However, all of the drives (including backups) were destroyed due to unforeseen circumstances, and you need to write one PowerShell script named “restore.ps1” that can accomplish all of the required tasks from the local server.

## REQUIREMENTS

Your submission must be your original work. No more than a combined total of 30% of a submission can be directly quoted or closely paraphrased from sources, even if cited correctly. Use the report provided when submitting your task as a guide.

 You must use the rubric to direct the creation of your submission because it provides detailed criteria that will be used to evaluate your work. Each requirement below may be evaluated by more than one rubric aspect. The rubric aspect titles may contain hyperlinks to relevant portions of the course.

A. Create a PowerShell script named “restore.ps1” within the “Requirements2” folder. For the first line, create a comment and include your first and last name along with your student ID.

Note: The remainder of this task shall be completed within the same script file, “restore.ps1.”

B. Write a single script within the “restore.ps1” file that performs all of the following functions without user interaction:

1. Create an Active Directory organizational unit (OU) named “finance.”

2. Import the financePersonnel.csv file (found in the “Requirements2” directory) into your Active Directory domain and directly into the finance OU. Be sure to include the following properties:

   - First Name
   - Last Name
   - Display Name (First Name + Last Name, including a space between)
   - Postal Code
   - Office Phone
   - Mobile Phone

3. Create a new database on the Microsoft SQL server instance called “ClientDB.”

4. Create a new table and name it “Client_A_Contacts.” Add this table to your new database.

5. Insert the data from the attached “NewClientData.csv” file (found in the “Requirements2” folder) into the table created in part B4.

C. Apply exception handling using try-catch for System.OutOfMemoryException.

D. Run the script within the Performance Assessment Lab Area environment. After the script executes successfully, run the following cmdlets individually from within your Requirements2 directory:

1. Get-ADUser -Filter * -SearchBase “ou=finance,dc=consultingfirm,dc=com” -Properties DisplayName,PostalCode,OfficePhone,MobilePhone > .\AdResults.txt

2. Invoke-Sqlcmd -Database ClientDB –ServerInstance .\SQLEXPRESS -Query ‘SELECT * FROM dbo.Client_A_Contacts’ > .\SqlResults.txt

Note: Ensure you have all of the following files intact within the “Requirements2” folder, including the original files:

- “restore.ps1”
- “AdResults.txt”
- “SqlResults.txt”

E. Compress the “Requirements2” folder as a ZIP archive. When you are ready to submit your final task, run the Get-FileHash cmdlet against the “Requirements2” ZIP archive. Note the hash value and place it into the comment section when you submit your task.

### File Restrictions

File name may contain only letters, numbers, spaces, and these symbols: ! - _ . * ' ( )
File size limit: 200 MB
File types allowed: doc, docx, rtf, xls, xlsx, ppt, pptx, odt, pdf, txt, qt, mov, mpg, avi, mp3, wav, mp4, wma, flv, asf, mpeg, wmv, m4v, svg, tif, tiff, jpeg, jpg, gif, png, zip, rar, tar, 7z
