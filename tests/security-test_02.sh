#!/bin/bash

################################################################################
# Deployment validation tests
# Secure, route and globally distribute a static website
#
## End-to-end tests implicitly validate many components (DNS, CloudFront, ACM, S3).
################################################################################

set -e  # Exit on error (disabled for test execution)
set +e  # Re-enabled below to allow tests to fail individually

# Color codes for terminal output
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Test counters
PASSED=0
FAILED=0
TOTAL=0



################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

log_test(){
  echo -e ""
  echo -e "${YELLOW}TEST #$((TOTAL + 1)): $1${NC}"
  TOTAL=$((TOTAL + 1))
}

pass(){
  echo -e "${GREEN}✓ SUCCESS${NC}: $1"
  PASSED=$((PASSED + 1))
}

fail(){
  echo -e "${RED}✗ FAILED${NC}: $1"
  FAILED=$((FAILED + 1))
}


################################################################################
# Configuration
################################################################################

# Loading terraform variables
DOMAIN_NAME="$(terraform output -raw website_domain)"
CLOUDFRONT_DISTRIBUTION_ID="$()"
S3_BUCKET_NAME="$(terraform output -raw s3_bucket_name)"
BUCKET_REGION="$(terraform output -raw bucket_region)"


################################################################################
# Security tests - PART 2
# S3 Access blocked, WAF reactivity, TLS certificate validity
################################################################################

security_headers(){

}

WAF_logging(){

}
################################################################################
# Main Execution
################################################################################

main () {
  print_header "Infrastructure Integrity Tests"
  echo "Domain : $DOMAIN_NAME"
  echo "Bucket region : $BUCKET_REGION"
  echo "Test start time: $(date)"

 # === Security tests === #
  print_header "Security tests"
  security_headers
  WAF_logging

  # === Summary ===
  print_header "Test Summary"
  echo "Test End Time: $(date)"
  echo ""
  echo "Total Tests:  $TOTAL"
  echo -e "${GREEN}Passed:       $PASSED${NC}"
  echo -e "${RED}Failed:       $FAILED${NC}"
}

main