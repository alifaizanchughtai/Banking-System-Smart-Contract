# Smart Contract Banking System

This repository contains a smart contract implemented in Solidity that serves as a decentralized banking system. The smart contract allows users to create accounts, deposit funds, withdraw funds, transfer funds, take and repay loans, and check balances securely on the Ethereum blockchain.

## Features

### Account Management:

- **Open Account**: Create a new account in the bank.
- **Get Account Details**: Fetch account details including balance, first name, last name, and loan amount.
- **Close Account**: Close an existing account, ensuring all loans are repaid.

### Funds Management:

- **Deposit Funds**: Deposit Ether into an account with a minimum deposit requirement.
- **Withdraw Funds**: Withdraw Ether from an account, ensuring sufficient balance.
- **Transfer Funds**: Transfer Ether from one account to another.

### Loan Management:

- **Top Up Loan Funds**: Owner can deposit Ether to increase the loan pool.
- **Take Loan**: Request a loan based on account balance and available loan funds.
- **Inquire Loan**: Check the outstanding loan amount.
- **Repay Loan**: Repay the outstanding loan amount partially or in full.

### Interest Management:

- **Set Interest Rates**: Owner can set interest rates for deposits and loans.
  - The rates are adjustable by the contract owner.
- **Add Deposit Interest**: Owner can add interest to all deposits based on the set interest rate.
  - Interest is calculated and added based on the deposit interest rate.
- **Add Loan Interest**: Owner can add interest to all loans based on the set interest rate.
  - Interest is calculated and added based on the loan interest rate.
