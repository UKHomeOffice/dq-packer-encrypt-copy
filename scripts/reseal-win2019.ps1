<powershell>

$EC2SettingsFile="$ENV:ProgramData\Amazon\EC2Launch\config\agent-config.yml"

$configContent = @"
version: 1.1
config:
  - stage: preReady
    tasks:
      - task: setAdminAccount
        inputs:
          password:
            type: random
      - task: setHostName
        inputs:
          reboot: true
      - task: executeScript
        inputs:
        - frequency: always
          type: powershell
          runAs: localSystem
          content: |-
            New-Item -Path 'C:\PowerShellTest.txt' -ItemType File
      - task: sysprep
        inputs:
          clean: true
          shutdown: true
"@

Set-Content -Path $EC2SettingsFile -Value $configContent

</powershell>
