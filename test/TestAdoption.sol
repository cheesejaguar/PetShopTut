pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Adoption.sol";

contract TestAdoption {
  Adoption adoption = Adoption(DeployedAddresses.Adoption());
  // Testing the adopt() function
  function testUserCanAdoptPet() public {
    uint returnedId = adoption.adopt(8);
    uint expected = 8;
    Assert.equal(returnedId, expected, "adopt() should return the adopted pet ID 8.");
  }
    // Testing retrieval of a single pet's owner
   function testGetAdopterAddressByPetId() public {
     // Expected owner is this contract
     address expected = this;
     address adopter = adoption.adopters(8);
     Assert.equal(adopter, expected, "Owner of pet ID 8 should be recorded.");
   }
   // Testing retrieval of all pet owners
  function testGetAdopterAddressByPetIdInArray() public {
    // Expected owner is this contract
    address expected = this;

    // Store adopters in memory rather than contract's storage
    address[16] memory adopters = adoption.getAdopters();

    Assert.equal(adopters[8], expected, "Owner of pet ID 8 should be recorded.");
    Assert.equal(adopters[0], address(0), "Pet ID 0 was never adopted and should have no owner.");
  }
  // Testing that pet IDs outside 0-15 are rejected
  function testAdoptRejectsOutOfRangePetId() public {
    bool succeeded = address(adoption).call(bytes4(keccak256("adopt(uint256)")), uint(16));
    Assert.isFalse(succeeded, "Adopting pet ID 16 should revert.");
  }
}
