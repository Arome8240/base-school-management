// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

error NotSchoolOwner();
error StudentAlreadyExists(address student);
error StudentNotFound(address student);
error InvalidScore(uint8 given);
error NotFactoryOwner();
error SchoolAlreadyExists(address id);
error SchoolNotFound(address id);
