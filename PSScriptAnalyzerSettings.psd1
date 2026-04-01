@{
  DefaultSeverity = 'Warning'
  Rules = @{
    PSUseApprovedVerbs = @{
      Severity = 'Warning'
    }
    PSAvoidUsingPlainTextForCredential = @{
      Severity = 'Error'
    }
    PSUseDeclaredLocalVariables = @{
      Severity = 'Warning'
    }
  }
}