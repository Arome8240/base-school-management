// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Management.sol";
import "../src/Error.sol";

contract ManagementTest is Test {
    Management public management;
    address public owner = address(this);
    address public studentId = address(1);

    function setUp() public {
        management = new Management(
            "My School",
            "12345",
            "School Address",
            "Principal Name",
            owner
        );
    }

    function testRegisterStudent() public {
        management.registerStudent(studentId, "John Doe", 10, 5);
        (string memory name, uint8 age, uint8 level, bool registered) = management.students(studentId);
        assertTrue(registered, "Student should be registered");
        assertEq(name, "John Doe", "Student name should be John Doe");
        assertEq(age, 10, "Student age should be 10");
        assertEq(level, 5, "Student level should be 5");
    }

    function testFailRegisterStudentAlreadyExists() public {
        management.registerStudent(studentId, "John Doe", 10, 5);
        vm.expectRevert(StudentAlreadyExists.selector);
        management.registerStudent(studentId, "Jane Doe", 11, 6);
    }

    function testPromoteStudent() public {
        management.registerStudent(studentId, "John Doe", 10, 5);
        management.promoteStudent(studentId);
        (,, uint8 level,) = management.students(studentId);
        assertEq(level, 6, "Student level should be 6");
    }

    function testFailPromoteStudentNotFound() public {
        vm.expectRevert(StudentNotFound.selector);
        management.promoteStudent(studentId);
    }

    function testScoreStudent() public {
        management.registerStudent(studentId, "John Doe", 10, 5);
        management.scoreStudent(studentId, "Math", 95);
        (, , , uint8 score) = management.getReportCard(studentId, "Math");
        assertEq(score, 95, "Student score for Math should be 95");
    }

    function testFailScoreStudentNotFound() public {
        vm.expectRevert(StudentNotFound.selector);
        management.scoreStudent(studentId, "Math", 95);
    }

    function testFailInvalidScore() public {
        management.registerStudent(studentId, "John Doe", 10, 5);
        vm.expectRevert(InvalidScore.selector);
        management.scoreStudent(studentId, "Math", 101);
    }

    function testGetReportCard() public {
        management.registerStudent(studentId, "John Doe", 10, 5);
        management.scoreStudent(studentId, "Math", 95);
        (string memory name, uint8 age, uint8 level, uint8 score) = management.getReportCard(studentId, "Math");
        assertEq(name, "John Doe", "Student name should be John Doe");
        assertEq(age, 10, "Student age should be 10");
        assertEq(level, 5, "Student level should be 5");
        assertEq(score, 95, "Student score for Math should be 95");
    }

    function testFailGetReportCardStudentNotFound() public {
        vm.expectRevert(StudentNotFound.selector);
        management.getReportCard(studentId, "Math");
    }

    function testFailOnlyOwner() public {
        vm.prank(address(2));
        vm.expectRevert(NotSchoolOwner.selector);
        management.registerStudent(studentId, "John Doe", 10, 5);

        vm.prank(address(2));
        vm.expectRevert(NotSchoolOwner.selector);
        management.promoteStudent(studentId);

        vm.prank(address(2));
        vm.expectRevert(NotSchoolOwner.selector);
        management.scoreStudent(studentId, "Math", 95);
    }
}
