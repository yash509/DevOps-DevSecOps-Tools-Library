# commands tp install Git Leaks

sudo apt install gitleaks -y

-- if the error comes like on VM like "it does not have packages for git leaks" use the below cmds
sudo apt update first
sudo apt install gitleaks -y

---------------------------------------------------------------------------------------------------------------------------------

# cmd to scan the particular target on the server
gitleaks detect --source target-name/ --e.g.: gitleaks detect --source leaky-repo/

# cmd to scan a repo and generate a report
-- json
gitleaks detect --source . -r gitleaks-report.json -f json

-- csv 
gitleaks detect --source . -r gitleaks-report.csv -f csv

-- txt
gitleaks detect --source . -r gitleaks-report.txt -f txt

# cmd to detect the for the last 10 or 20 or 30 commits only in a repo
-- Last 10 commits and generate a report in json
gitleaks detect --source . --logs-opts="-10" -r gitleaks-report.json -f json
gitleaks detect --source . --logs-opts="-10" -r gitleaks-report.csv -f csv
gitleaks detect --source . --logs-opts="-10" -r gitleaks-report.txt -f txt

-- Last 20 commits and generate a report in json
gitleaks detect --source . --logs-opts="-20" -r gitleaks-report.json -f json
gitleaks detect --source . --logs-opts="-20" -r gitleaks-report.csv -f csv
gitleaks detect --source . --logs-opts="-20" -r gitleaks-report.txt -f txt

-- Last 30 commits and generate a report in json
gitleaks detect --source . --logs-opts="-30" -r gitleaks-report.json -f json
gitleaks detect --source . --logs-opts="-30" -r gitleaks-report.csv -f csv
gitleaks detect --source . --logs-opts="-30" -r gitleaks-report.txt -f txt
