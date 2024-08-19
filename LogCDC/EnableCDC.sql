
-- Enable log based cdc on the database
EXEC sys.sp_cdc_enable_db;

-- Disable log based cdc on the database (if needed)
EXEC sys.sp_cdc_disable_db;

-- Enable clr on the database
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;

-- Check if the clr is enable correctly
EXEC sp_configure 'clr enabled';

EXEC sys.sp_cdc_help_change_data_capture;

-- Enable cdc on all tables that i want to track
EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'Person',
    @role_name = NULL,
    @capture_instance = null,
    @supports_net_changes = 1,
    @captured_column_list = N'PersonID, FirstName, LastName, Email, PhoneNumber, Address';

EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'Customer',
    @role_name = NULL,
    @capture_instance = null,
    @supports_net_changes = 1,
    @captured_column_list = N'CustomerID, CustomerType, PersonID';

EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'Employee',
    @role_name = NULL,
    @capture_instance = null,
    @supports_net_changes = 1,
    @captured_column_list = N'EmployeeID, Position, PersonID, BranchID';

EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'Account',
    @role_name = NULL,
    @capture_instance = null,
    @supports_net_changes = 1,
    @captured_column_list = N'AccountID, AccountType, AccountBalance, AccountOpened, AccountClosed, CustomerID';

EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'Loan',
    @role_name = NULL,
    @capture_instance = null,
    @supports_net_changes = 1,
    @captured_column_list = N'LoanID, LoanType, LoanAmount, LoanInterestRate, LoanTerm, LoanStartDate, LoanEndDate, LoanStatus, CustomerID';

EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'LoanPayment',
    @role_name = NULL,
    @capture_instance = null,
    @supports_net_changes = 1,
    @captured_column_list = N'LoanPaymentID, PaymentAmount, PaymentDate, LoanID';

EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'Transactions',
    @role_name = NULL,
    @capture_instance = null,
    @supports_net_changes = 1,
    @captured_column_list = N'TransactionID, TransactionDate, TransactionAmount, TransactionType, AccountID, EmployeeID, LoanPaymentID';
GO

-- Disable the cdc on all tables, if changes in the table is needed (Reason: CDC doesn't allow changes in the table that is included in the CDC)
EXEC sys.sp_cdc_disable_table
    @source_schema = N'dbo',
    @source_name = N'Person',
    @capture_instance = dbo_Person;
Exec sys.sp_cdc_disable_table
    @source_schema = N'dbo',
    @source_name = N'Customer',
    @capture_instance = dbo_Customer;
Exec sys.sp_cdc_disable_table
    @source_schema = N'dbo',
    @source_name = N'Employee',
    @capture_instance = dbo_Employee;
Exec sys.sp_cdc_disable_table
    @source_schema = N'dbo',
    @source_name = N'Account',
    @capture_instance = dbo_Account;
Exec sys.sp_cdc_disable_table
    @source_schema = N'dbo',
    @source_name = N'Loan',
    @capture_instance = dbo_Loan;
Exec sys.sp_cdc_disable_table
    @source_schema = N'dbo',
    @source_name = N'LoanPayment',
    @capture_instance = dbo_LoanPayment;
Exec sys.sp_cdc_disable_table
    @source_schema = N'dbo',
    @source_name = N'Transactions',
    @capture_instance = dbo_Transactions;
