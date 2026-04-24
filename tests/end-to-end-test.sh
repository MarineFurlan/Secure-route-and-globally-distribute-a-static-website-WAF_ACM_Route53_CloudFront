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
S3_BUCKET_NAME="$()"
BUCKET_REGION="$()"

################################################################################
# End-to-End Tests
# These tests implicitly validate: DNS, CloudFront deployment, ACM certificate,
# S3 bucket existence, bucket content, and basic connectivity
################################################################################

website_https_accessibility(){
  log_test "Website Accessibility via HTTPS"
  echo "Accessing "https://${DOMAIN_NAME}""
  http_code=$(curl -s -o /dev/null -w "%{http_code}" "https://${DOMAIN_NAME}")

  if [ "$http_code" = "200" ]; then
    pass "Website accessible at https://${DOMAIN_NAME}"
    echo "✓ Implicitly validates: DNS resolution, CloudFront deployment, ACM certificate, S3 bucket & content"
    return 0
  else
    fail "Website returned HTTP $http_code (expected 200)"
    return 1
  fi
}

http_to_https_redirect(){
  log_test "HTTP to HTTPS Redirect"
  echo "Accessing "http://${DOMAIN_NAME}""

  final_url=$(curl -s -o /dev/null -w "%{url_effective}" -L "http://${DOMAIN_NAME}")

  if [[ "$final_url" == https://* ]]; then
    pass "HTTP redirects to HTTPS (final: $final_url)"
    return 0
  else
    fail "HTTP does not redirects to HTTPS (final: $final_url)"
    return 1
  fi
}


################################################################################
# Main Execution
################################################################################

main () {
  print_header "Infrastructure Integrity Tests"
  echo "Domain : $DOMAIN_NAME"
  echo "Bucket region : $BUCKET_REGION"
  echo "Test start time: $(date)"

  # === End-to-end tests === #
  print_header "End-to-end tests"
  website_https_accessibility
  http_to_https_redirect

  # === Summary ===
  print_header "Test Summary"
  echo "Test End Time: $(date)"
  echo ""
  echo "Total Tests:  $TOTAL"
  echo -e "${GREEN}Passed:       $PASSED${NC}"
  echo -e "${RED}Failed:       $FAILED${NC}"
}

main