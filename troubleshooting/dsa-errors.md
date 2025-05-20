# Common AD Errors and Fixes

## Error: Domain not found
- Check DNS
- Run: `nltest /dsgetdc:corp.local`

## Error: SPN Conflict
- Run: `setspn -X`

## Error: Secure channel broken
- Fix with: `Test-ComputerSecureChannel -Repair`