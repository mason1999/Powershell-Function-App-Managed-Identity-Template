param($Request, $TriggerMetadata)

function Get-AccessToken {
    $ResourceUri = "https://management.azure.com"
    $TokenAuthURI = "${env:IDENTITY_ENDPOINT}?resource=${ResourceUri}&api-version=2019-08-01"
    $TokenResponse = Invoke-RestMethod -Method Get -Headers @{ "X-IDENTITY-HEADER" = "${env:IDENTITY_HEADER}" } -Uri "${TokenAuthUri}"
    return $TokenResponse.access_token
}

########## BEGIN SCRIPT ##########
switch ($Request.Method) {
    "OPTIONS" {
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = 200
                Headers    = @{
                    "Webhook-Allowed-Origin" = "$($Request.Headers["Webhook-Request-Origin"])"
                }
            })
    }
    "POST" {
        Write-Host "Access token is: $(Get-AccessToken)"
    }
}

