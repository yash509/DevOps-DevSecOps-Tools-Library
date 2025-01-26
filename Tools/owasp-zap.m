docker pull ghcr.io/zaproxy/zaproxy:stable


docker run -v \$(pwd):/zap/wrk/:rw --network=\"host\" zaproxy/zap-stable zap-baseline.py -t http://15.206.125.79:5000 || true




--- jenkins pipeline stage
stage('OWASP ZAP Penetration Testing - DAST'){
            steps {
                sh "docker run -v \$(pwd):/zap/wrk/:rw --network=\"host\" zaproxy/zap-stable zap-baseline.py -t http://15.206.125.79:5000 || true"
            }
        }
