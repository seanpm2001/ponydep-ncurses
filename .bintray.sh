REPO_TYPE=$1        # e.g., rpm | debian | source
PACKAGE_VERSION=$2  # e.g., 0.2.1-234.master.abcdefa
PACKAGE_NAME=$3     # e.g., ponyc-master | ponyc-release

# TODO: cut "ponyc" out of the repo names
BINTRAY_REPO_NAME="ponyc-$REPO_TYPE"
OUTPUT_TARGET="bintray_${REPO_TYPE}_${PACKAGE_NAME}.yml"

DATE=`date +%Y-%m-%d`

case "$REPO_TYPE" in
  "debian")
    FILES="\"files\":
        [
          {
            \"includePattern\": \"\\\\/home\\\\/travis\\\\/build\\\\/killerswan\\\\/ponydep-ncurses\\\\/build\\\\/bin\\\\/(.*\\\\.deb)\", \"uploadPattern\": \"\$1\",
            \"matrixParams\": {
            \"deb_distribution\": \"killerswan\",
            \"deb_component\": \"main\",
            \"deb_architecture\": \"amd64\"}
         }
       ],
       \"publish\": true" 
    ;;
  "rpm")
    FILES="\"files\":
      [
        {\"includePattern\": \"\\\\/home\\\\/travis\\\\/build\\\\/killerswan\\\\/ponydep-ncurses\\\\/build\\\\/bin\\\\/(${PACKAGE_NAME}-${PACKAGE_VERSION}.*\\\\.rpm)\", \"uploadPattern\": \"\$1\"}
      ],
    \"publish\": true" 
    ;;
  "source")
    FILES="\"files\":
      [
        {\"includePattern\": \"\\\\/home\\\\/travis\\\\/build\\\\/killerswan\\\\/ponydep-ncurses\\\\/build\\\\/bin\\\\/(.*\\\\.tar.bz2)\", \"uploadPattern\": \"\$1\"}
      ],
    \"publish\": true"
    ;;
esac

YAML="{
  \"package\": {
    \"repo\": \"$BINTRAY_REPO_NAME\",
    \"name\": \"$PACKAGE_NAME\",
    \"subject\": \"killerswan\"
  },
  \"version\": {
    \"name\": \"$PACKAGE_VERSION\",
    \"desc\": \"An RPM to satisfy the ponyc dependency on ncurses\",
    \"released\": \"$DATE\",
    \"vcs_tag\": \"$PACKAGE_VERSION\",
    \"gpgSign\": false
  },"

YAML="$YAML$FILES}"

echo "Writing YAML to file: $OUTPUT_TARGET, from within `pwd` ..."
echo "$YAML" >> "$OUTPUT_TARGET"

echo "=== WRITTEN FILE =========================="
cat -v "$OUTPUT_TARGET"
echo "==========================================="

