// Parameters
param logAnalyticsWorkspace string
param location string

// Resources

resource log_workspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: logAnalyticsWorkspace
  location: location
}

// Outputs

output log_workspace_id string = log_workspace.id
