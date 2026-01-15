// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SchoolFactory.sol";
import "../src/Management.sol";
import "../src/Error.sol";

contract SchoolFactoryTest is Test {
    SchoolFactory public schoolFactory;
    address public factoryOwner;
    address public schoolId = address(1);

    function setUp() public {
        factoryOwner = address(this);
        schoolFactory = new SchoolFactory();
    }

    function testRegisterSchool() public {
        schoolFactory.registerSchool(
            schoolId,
            "School One",
            "POB1",
            "Address One",
            "Principal One"
        );
        address schoolAddress = schoolFactory.schools(schoolId);
        assertNotEq(schoolAddress, address(0), "School address should not be zero");
    }

    function testFailRegisterSchoolAlreadyExists() public {
        schoolFactory.registerSchool(
            schoolId,
            "School One",
            "POB1",
            "Address One",
            "Principal One"
        );
        vm.expectRevert(SchoolAlreadyExists.selector);
        schoolFactory.registerSchool(
            schoolId,
            "School Two",
            "POB2",
            "Address Two",
            "Principal Two"
        );
    }

    function testGetSchool() public {
        schoolFactory.registerSchool(
            schoolId,
            "School One",
            "POB1",
            "Address One",
            "Principal One"
        );
        address retrievedSchoolAddress = schoolFactory.getSchool(schoolId);
        assertNotEq(retrievedSchoolAddress, address(0), "Retrieved school address should not be zero");
    }

    function testFailGetSchoolNotFound() public {
        vm.expectRevert(SchoolNotFound.selector);
        schoolFactory.getSchool(schoolId);
    }

    function testFailOnlyOwner() public {
        address otherUser = address(2);
        vm.prank(otherUser);
        vm.expectRevert(NotFactoryOwner.selector);
        schoolFactory.registerSchool(
            schoolId,
            "School One",
            "POB1",
            "Address One",
            "Principal One"
        );
    }
}
