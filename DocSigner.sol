// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentSigning {
    address public owner;
    mapping(address => bool) public whitelist;
    mapping(uint256 => mapping(address => bool)) public signedDocuments;

    event DocumentSigned(address indexed signer, uint256 documentId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "Only whitelisted addresses can sign documents");
        _;
    }

    constructor(address[] memory initialWhitelist) {
        owner = msg.sender;
        addToWhitelist(owner); // Owner is automatically whitelisted
        for (uint256 i = 0; i < initialWhitelist.length; i++) {
            addToWhitelist(initialWhitelist[i]);
        }
    }

    function addToWhitelist(address _address) public onlyOwner {
        whitelist[_address] = true;
    }

    function removeFromWhitelist(address _address) public onlyOwner {
        whitelist[_address] = false;
    }

    function signDocument(uint256 documentId) public onlyWhitelisted {
        require(!signedDocuments[documentId][msg.sender], "Address has already signed the document");
        signedDocuments[documentId][msg.sender] = true;
        emit DocumentSigned(msg.sender, documentId);
    }
}
