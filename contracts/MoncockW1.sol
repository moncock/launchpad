// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MoncockW1 is ERC721A, Ownable {

    // config
    constructor(address initialOwner) ERC721A("Moncock W1", "MONCOCKW1") Ownable(initialOwner) {}
    uint256 public MAX_SUPPLY = 1_000;                                      // **TODO** 10_000;
    uint256 public MAX_MINT_PER_WALLET = 5;                                 // **TODO** 2;
    uint256 public START_ID = 1;

    bool public mintEnabled = true;
    string public baseURI = "https://moncock.github.io/sample-1000/json/";  // **TODO**

    // start token id
    function _startTokenId() internal view virtual override returns (uint256) {
        return START_ID;
    }

    // metadata
    function setBaseURI(string calldata _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return string.concat(baseURI, Strings.toString(tokenId), ".json");
    }

    // toggle sale, round
    function toggleSale() external onlyOwner {
        mintEnabled = !mintEnabled;
    }

    // mint
    function mint(uint quantity, bytes32[] calldata _merkleProof) external {
        require(mintEnabled, "Sale is not enabled");
        require(_numberMinted(msg.sender) + quantity <= MAX_MINT_PER_WALLET, "Over wallet limit");
        
        _checkSupplyAndMint(msg.sender, quantity);
    }
    function adminMint(uint quantity) external onlyOwner {
        _checkSupplyAndMint(msg.sender, quantity);
    }
    function _checkSupplyAndMint(address to, uint256 quantity) private {
        require(_totalMinted() + quantity <= MAX_SUPPLY, "Over supply");

        _mint(to, quantity);
    }

    // aliases
    function numberMinted(address owner) external view returns (uint256) {
        return _numberMinted(owner);
    }
    function remainingSupply() external view returns (uint256) {
        return MAX_SUPPLY - _totalMinted();
    }

}