// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

contract BankingSystem {
    // DECLARATIONS

    struct Account {
        string firstName;
        string lastName;
        uint256 loanAmount;
        uint256 balance;
        bool exists;
    }

    mapping(address => Account) public accounts;

    address private owner;

    uint256 private loan_funds;
    uint256 private depositInterestRate;
    uint256 private loanInterestRate;

    address[] private accountsList;

    // Constructor
    constructor() {
        owner = tx.origin;
        loan_funds = 0;
        depositInterestRate = 0;
        loanInterestRate = 0;
    }

    // Create An Account In The Bank
    function openAccount(string memory firstName, string memory lastName)
        public
    {
        require(tx.origin != owner, "Error, Owner Prohibited");

        require(accounts[tx.origin].exists == false,"Account already exists");

        accounts[tx.origin] = Account({
            firstName: firstName,
            lastName: lastName,
            loanAmount: 0,
            balance: 0,
            exists: true
        });

        accountsList.push(tx.origin);
    }

    // Fetch Account Details
    function getDetails()
        public
        view
        returns (
            uint256 balance,
            string memory first_name,
            string memory last_name,
            uint256 loanAmount
        )
    {
        require(accounts[tx.origin].exists, "No Account");

        return (
            accounts[tx.origin].balance,
            accounts[tx.origin].firstName,
            accounts[tx.origin].lastName,
            accounts[tx.origin].loanAmount
        );
    }

    // Deposit Funds Into Account
    // minimum deposit of 1 ether.
    // 1 ether = 10^18 Wei.
    function depositAmount() public payable {
    
        require(accounts[tx.origin].exists, "No Account");

        require(msg.value >= 1000000000000000000, "Low Deposit");

        accounts[tx.origin].balance += msg.value;
    }

    // Withdraw Funds From Account
    function withDraw(uint256 withdrawalAmount) public {
        
        require(tx.origin != owner, "Error, Owner Prohibited");

        require(accounts[tx.origin].exists, "No Account");

        require(withdrawalAmount <= accounts[tx.origin].balance,"Insufficient Funds");

        payable(tx.origin).transfer(withdrawalAmount);

        accounts[tx.origin].balance -= withdrawalAmount;
    }

    // Transfer Funds To Another Account
    function TransferEth(address payable recipient, uint256 transferAmount)
        public
    {
        require(tx.origin != owner, "Error, Owner Prohibited");

        require(accounts[tx.origin].exists, "No Account");

        require(transferAmount <= accounts[tx.origin].balance,"Insufficient Funds");

        accounts[tx.origin].balance -= transferAmount;

        accounts[recipient].balance += transferAmount;
    }

    // Top Up Loan Funds
    function depositTopUp() public payable {
        
        require(tx.origin == owner, "Only Owner can call this function");

        loan_funds += msg.value;
    }

    // Issue Request For Loan
    function TakeLoan(uint256 loanAmount) public {
        
        require(tx.origin != owner, "Error, Owner Prohibited");

        require(accounts[tx.origin].exists, "No Account");

        require(loanAmount <= 2 * accounts[tx.origin].balance,"Loan Limit Exceeded");

        require(loanAmount <= loan_funds, "Insufficient Loan Funds");

        loan_funds -= loanAmount;

        accounts[tx.origin].loanAmount += loanAmount;

        payable(tx.origin).transfer(loanAmount);
    }

    // Return Current Loan Amount
    function InquireLoan() public view returns (uint256 loanValue) {

        require(accounts[tx.origin].exists, "No Account");

        loanValue = accounts[tx.origin].loanAmount;
        return loanValue;
    }

    // Pay Outstanding Loans
    function returnLoan() public payable {
        
        require(accounts[tx.origin].exists, "No Account");

        require(accounts[tx.origin].loanAmount > 0, "No Loan");

        require(msg.value <= accounts[tx.origin].loanAmount,"Owed Amount Exceeded");

        accounts[tx.origin].loanAmount -= msg.value;

        loan_funds += msg.value;
    }

    // Set Interest Rates On Loans And Deposits
    function setInterestRates(
        uint256 dep_interest_rate,
        uint256 loan_interest_rate
    ) public {
    
        require(tx.origin == owner,"Only the owner can set interest rates");

        depositInterestRate = dep_interest_rate;

        loanInterestRate = loan_interest_rate;
    }

    // Add Interest On Deposits
    function addDepositInterest() public {
    
        require(tx.origin == owner,"Only the owner can add interest to deposits");

        for (uint256 i = 0; i < accountsList.length; i++) {
            address account = accountsList[i];
            uint256 interest = (accounts[account].balance * depositInterestRate) / 100;
            accounts[account].balance += interest;
        }
    }

    // Add Interest On Loans
    function addLoanInterest() public {

        require(tx.origin == owner,"Only the owner can add interest to loans");

        for (uint256 i = 0; i < accountsList.length; i++) {
            address account = accountsList[i];
            uint256 interest = (accounts[account].loanAmount * loanInterestRate) / 100;
            accounts[account].loanAmount += interest;
        }
    }

    // Account Closure
    function closeAccount() public {

        require(tx.origin != owner, "Error, Owner does not own an account");

        require(accounts[tx.origin].exists, "No Account Exists");

        require(accounts[tx.origin].loanAmount == 0,"Dues remaining, cannot close account before repayment");

        delete accounts[tx.origin];

        for (uint256 i = 0; i < accountsList.length; i++) {
            if (accountsList[i] == tx.origin) {
                accountsList[i] = accountsList[accountsList.length - 1];
                accountsList.pop();
                break;
            }
        }
    }

    function AmountInBank() public view returns (uint256) {
        // DONT ALTER THIS FUNCTION
        return address(this).balance;
    }

    function DepositInterestRate() public view returns (uint256) {
        // DONT ALTER THIS FUNCTION
        return depositInterestRate;
    }

    function LoanInterestRate() public view returns (uint256) {
        // DONT ALTER THIS FUNCTION
        return loanInterestRate;
    }

    function LoanFunds() public view returns (uint256) {
        // DONT ALTER THIS FUNCTION
        return loan_funds; // this is your reserve amount.
    }
}
