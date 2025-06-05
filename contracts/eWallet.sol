// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract USDCTransfer is ReentrancyGuard, Ownable {
    IERC20 public immutable usdc;
    
    // Events
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event BatchTransfer(address indexed from, address[] recipients, uint256[] amounts);
    
    // USDC contract addresses for different networks
    // Ethereum Mainnet: 0xA0b86a33E6441E8c4c4ab9b07e2F8E3b9b9b4b4f
    // Polygon: 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174
    // Arbitrum: 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8
    
    constructor(address _usdcAddress) {
        require(_usdcAddress != address(0), "Invalid USDC address");
        usdc = IERC20(_usdcAddress);
    }
    
    /**
     * @dev Transfer USDC from sender to recipient
     * @param recipient The address to receive USDC
     * @param amount The amount of USDC to transfer (in wei, 6 decimals for USDC)
     */
    function transferUSDC(address recipient, uint256 amount) external nonReentrant {
        require(recipient != address(0), "Invalid recipient address");
        require(amount > 0, "Amount must be greater than 0");
        
        // Check sender's balance
        require(usdc.balanceOf(msg.sender) >= amount, "Insufficient USDC balance");
        
        // Check allowance
        require(usdc.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance");
        
        // Transfer USDC from sender to recipient
        bool success = usdc.transferFrom(msg.sender, recipient, amount);
        require(success, "USDC transfer failed");
        
        emit Transfer(msg.sender, recipient, amount);
    }
    
    /**
     * @dev Transfer USDC to multiple recipients in a single transaction
     * @param recipients Array of recipient addresses
     * @param amounts Array of amounts corresponding to each recipient
     */
    function batchTransferUSDC(
        address[] calldata recipients, 
        uint256[] calldata amounts
    ) external nonReentrant {
        require(recipients.length == amounts.length, "Arrays length mismatch");
        require(recipients.length > 0, "No recipients specified");
        require(recipients.length <= 100, "Too many recipients"); // Gas limit protection
        
        uint256 totalAmount = 0;
        
        // Calculate total amount and validate inputs
        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            require(amounts[i] > 0, "Amount must be greater than 0");
            totalAmount += amounts[i];
        }
        
        // Check sender's balance and allowance
        require(usdc.balanceOf(msg.sender) >= totalAmount, "Insufficient USDC balance");
        require(usdc.allowance(msg.sender, address(this)) >= totalAmount, "Insufficient allowance");
        
        // Execute transfers
        for (uint256 i = 0; i < recipients.length; i++) {
            bool success = usdc.transferFrom(msg.sender, recipients[i], amounts[i]);
            require(success, "USDC transfer failed");
        }
        
        emit BatchTransfer(msg.sender, recipients, amounts);
    }
    
    /**
     * @dev Check USDC balance of an address
     * @param account The address to check balance for
     * @return The USDC balance
     */
    function getUSDCBalance(address account) external view returns (uint256) {
        return usdc.balanceOf(account);
    }
    
    /**
     * @dev Check allowance given to this contract by an address
     * @param owner The address that gave the allowance
     * @return The allowance amount
     */
    function getAllowance(address owner) external view returns (uint256) {
        return usdc.allowance(owner, address(this));
    }
    
    /**
     * @dev Emergency function to withdraw any tokens accidentally sent to this contract
     * @param token The token contract address
     * @param amount The amount to withdraw
     */
    function emergencyWithdraw(address token, uint256 amount) external onlyOwner {
        require(token != address(0), "Invalid token address");
        IERC20(token).transfer(owner(), amount);
    }
}