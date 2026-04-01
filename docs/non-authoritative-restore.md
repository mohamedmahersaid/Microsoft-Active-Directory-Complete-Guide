# Non-Authoritative Restore

## Overview
A non-authoritative restore is a method used to recover Active Directory objects and attributes without affecting the rest of the directory. This is particularly useful when you need to restore deleted objects without losing more recent changes.

## Steps
1. Boot the domain controller in Directory Services Restore Mode (DSRM).
2. Restore the system state backup.
3. Reboot the domain controller in normal mode.

## Considerations
- Ensure you understand the implications of restoring objects.
- This method does not restore the most recent changes to the objects that may have occurred after the backup was taken.
