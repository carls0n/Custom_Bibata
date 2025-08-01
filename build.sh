#!/bin/bash

show_help(){
  cat <<EOF
Usage: $(basename "$0") [OPTION]
Build the mighty Bibata Cursor Theme.

If only the name is specified, it must match one of the predefined themes.

If a color is specified, then also a name must be provided.

Options:
  -c RGB, --color=RGB         Build cursor theme with this color (e.g. \"#ff00ff\")
  -b BORDER, --border=RGB     Use this color for border instead of a white border.
  -b BORDER, --border=None    Don't use any border
  -s STYLE, --style=Classic   Use classic style pointer instead of modern.
  -n NAME, --name=NAME        Build theme with this name
  -f, --force                 Overwrite if theme with same name was already built
  -h, --help                  Show this message

Predefined Themes:
  - Bibata_Arch
  - Bibata_Debian
  - Bibata_Void

Exit Codes:
  0 if everthing is OK,
  1 if dependencies not met,
  2 if incorrect arguments,
  3 if some other error occured
EOF
}

shopt -s nocasematch

# Check dependencies
if  ! type "inkscape" > /dev/null ; then
  echo "FAIL: inkscape must be installed"
  exit 1
fi
if  ! type "xcursorgen" > /dev/null ; then
  echo "FAIL: xcursorgen must be installed"
  exit 1
fi

# Predifined themes
declare -A themes
themes["Bibata_Arch"]="#1793d0"
themes["Bibata_Debian"]="#d70a53"
themes["Bibata_Void"]="#d5d7d4"

# Read arguments
BORDER=""
STYLE=""
RGB=""
THEME=""
FORCE=false
while [ -n "$1" ]; do
  case $1 in
    -c)
      RGB="$2"
      shift 2
      ;;
    --color)
      RGB="${1#*=}"
      shift
      ;;  
    -f|--force)
      FORCE=true;
      shift
      ;;
    -n)
      THEME="$2"
      shift 2
      ;;
    --name)
      THEME="${1#*=}"
      shift
      ;;   
    -b)
      BORDER="$2"
      shift 2
     ;;
    --border)
      BORDER="${1#*=}"
    shift
     ;;    
-s)
    STYLE="$2"
shift 2
;;
--style)
STYLE="${1#*=}"
shift
;;


    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "error: invalid argument: $1"
      exit 2
      ;;
  esac
done

# Find RGB values of the provided theme name
if [ "" = "$RGB" ] && [ "" != "$THEME" ]; then
  RGB=${themes["$THEME"]};
  if [ "" = "$RGB" ]; then
    echo "FAIL: No theme with name ${THEME} found"
    exit 2
  fi
fi

# Exit if not enough info
if [ "" = "$RGB" ] || [ "" = "$THEME" ]; then
  echo "FAIL: Both color and name must be provided"
  exit 2
fi

# Let's do it!
echo "Building \"${THEME}\" with color ${RGB}"

# Got to base directory
cd "$( dirname "${BASH_SOURCE[0]}" )" || exit


# Remove already existing build with the same name
if ([ -d "./src/${THEME}" ] || [ -d "./build/${THEME}" ]) && [ "true" != "$FORCE" ]; then
  echo "FAIL: Theme already exists."
  exit 3
fi
rm -rf "./src/${THEME}"
rm -rf "./build/${THEME}"

# Copy base theme (which is Bibata_Dark_Red)
cp -r "./src/Bibata_Base" "./src/${THEME}"

if [[ ${STYLE} == "classic" ]]; then
mv "./src/${THEME}/svgs/default2.svg" "./src/${THEME}/svgs/default.svg"
mv "./src/${THEME}/svgs/right_ptr_2.svg" "./src/${THEME}/svgs/right_ptr.svg"
fi

# set some paths
RAWSVGS="src/${THEME}/svgs"
CURSOR="src/${THEME}/cursor.theme"
INDEX="src/${THEME}/index.theme"
ALIASES="src/cursorList"

if [[ "${BORDER}" ]]; then
find "$RAWSVGS" -regex ".*\.svg" -type f -print0 \
  | xargs -0 sed -i "s/#ffffff/${BORDER}/g"
fi

if [[ "${BORDER}" == "None" ]]; then
find "$RAWSVGS" -regex ".*\.svg" -type f -print0 \
  | xargs -0 sed -i "s/#ffffff/${RGB}/g"
fi


# Set RGB values in all SVGs
find "$RAWSVGS" -regex ".*\.svg" -type f -print0 \
  | xargs -0 sed -i "s/#a40000/${RGB}/g"


# set name in "index.theme"
# TODO: find out why the name is "Bibata_Red" if it is actually "Bibata_Dark_Red"
sed -i "s/Bibata_Red/${THEME}/g" "src/${THEME}/index.theme"

# set name in "cursor.theme"    
sed -i "s/Bibata_Dark_Red/${THEME}/g" "src/${THEME}/cursor.theme"

# Create build folders
echo -ne "Making Folders... $BASENAME\\r"
DIR11X="build/${THEME}/96x96"
DIR10X="build/${THEME}/88x88"
DIR9X="build/${THEME}/80x80"
DIR8X="build/${THEME}/72x72"
DIR7X="build/${THEME}/64x64"
DIR6X="build/${THEME}/56x56"
DIR5X="build/${THEME}/48x48"
DIR4X="build/${THEME}/40x40"
DIR3X="build/${THEME}/32x32"
DIR2X="build/${THEME}/28x28"
DIR1X="build/${THEME}/24x24"

OUTPUT="$(grep --only-matching --perl-regex "(?<=Name\=).*$" $CURSOR)"
OUTPUT=${OUTPUT// /_}

mkdir -p \
      "$DIR11X" \
      "$DIR10X" \
      "$DIR9X" \
      "$DIR8X" \
      "$DIR7X" \
      "$DIR6X" \
      "$DIR5X" \
      "$DIR4X" \
      "$DIR3X" \
      "$DIR2X" \
      "$DIR1X"
mkdir -p "$OUTPUT/cursors"

echo 'Making Folders... DONE';


for CUR in src/config/*.cursor; do
  BASENAME=$CUR
  BASENAME=${BASENAME##*/}
  BASENAME=${BASENAME%.*}
  echo -ne "\033[0KGenerating simple cursor pixmaps for ${THEME}... $BASENAME\\r"
  inkscape -w 24 -h 24  $RAWSVGS/"$BASENAME".svg -o  "$DIR1X/$BASENAME.png" > /dev/null
  inkscape -w 28 -h 28  $RAWSVGS/"$BASENAME".svg -o  "$DIR2X/$BASENAME.png" > /dev/null
  inkscape -w 32 -h 32  $RAWSVGS/"$BASENAME".svg -o  "$DIR3X/$BASENAME.png" > /dev/null
  inkscape -w 40 -h 40  $RAWSVGS/"$BASENAME".svg -o  "$DIR4X/$BASENAME.png" > /dev/null
  inkscape -w 48 -h 48  $RAWSVGS/"$BASENAME".svg -o  "$DIR5X/$BASENAME.png" > /dev/null
  inkscape -w 56 -h 56  $RAWSVGS/"$BASENAME".svg -o  "$DIR6X/$BASENAME.png" > /dev/null
  inkscape -w 64 -h 64  $RAWSVGS/"$BASENAME".svg -o  "$DIR7X/$BASENAME.png" > /dev/null
  inkscape -w 72 -h 72  $RAWSVGS/"$BASENAME".svg -o  "$DIR8X/$BASENAME.png" > /dev/null
  inkscape -w 80 -h 80  $RAWSVGS/"$BASENAME".svg -o  "$DIR9X/$BASENAME.png" > /dev/null
  inkscape -w 88 -h 88  $RAWSVGS/"$BASENAME".svg -o  "$DIR10X/$BASENAME.png" > /dev/null
  inkscape -w 96 -h 96  $RAWSVGS/"$BASENAME".svg -o  "$DIR11X/$BASENAME.png" > /dev/null
done

echo -e "\033[0KGenerating simple cursor pixmaps for ${THEME}... DONE"

sleep 1s

echo -ne "\033[0KGenerating Animated Cursor ${THEME}...\\r"

for i in $(seq -f "%02g" 1 45); do
  echo -ne "\033[0KGenerating animated cursor pixmaps for ${THEME} Progress... $i / 45 \\r"
  inkscape -w 24 -h 24  $RAWSVGS/progress-$i.svg -o  "$DIR1X/progress-$i.png" > /dev/null
  inkscape -w 28 -h 28  $RAWSVGS/progress-$i.svg -o  "$DIR2X/progress-$i.png" > /dev/null
  inkscape -w 32 -h 32  $RAWSVGS/progress-$i.svg -o  "$DIR3X/progress-$i.png" > /dev/null
  inkscape -w 40 -h 40  $RAWSVGS/progress-$i.svg -o  "$DIR4X/progress-$i.png" > /dev/null
  inkscape -w 48 -h 48  $RAWSVGS/progress-$i.svg -o  "$DIR5X/progress-$i.png" > /dev/null
  inkscape -w 56 -h 56  $RAWSVGS/progress-$i.svg -o  "$DIR6X/progress-$i.png" > /dev/null
  inkscape -w 64 -h 64  $RAWSVGS/progress-$i.svg -o  "$DIR7X/progress-$i.png" > /dev/null
  inkscape -w 72 -h 72  $RAWSVGS/progress-$i.svg -o  "$DIR8X/progress-$i.png" > /dev/null
  inkscape -w 80 -h 80  $RAWSVGS/progress-$i.svg -o  "$DIR9X/progress-$i.png" > /dev/null
  inkscape -w 88 -h 88  $RAWSVGS/progress-$i.svg -o  "$DIR10X/progress-$i.png" > /dev/null
  inkscape -w 96 -h 96  $RAWSVGS/progress-$i.svg -o  "$DIR11X/progress-$i.png" > /dev/null
done

echo -e "\033[0KGenerating animated cursor pixmaps for ${THEME} Progress... DONE"


sleep 5s

for i in $(seq -f "%02g" 1 45); do
  echo -ne "\033[0KGenerating animated cursor pixmaps for ${THEME} Wait... $i / 45 \\r"

  inkscape -w 24 -h 24  $RAWSVGS/wait-$i.svg  -o "$DIR1X/wait-$i.png" > /dev/null
  inkscape -w 28 -h 28  $RAWSVGS/wait-$i.svg  -o "$DIR2X/wait-$i.png" > /dev/null
  inkscape -w 32 -h 32  $RAWSVGS/wait-$i.svg  -o "$DIR3X/wait-$i.png" > /dev/null
  inkscape -w 40 -h 40  $RAWSVGS/wait-$i.svg  -o "$DIR4X/wait-$i.png" > /dev/null
  inkscape -w 48 -h 48  $RAWSVGS/wait-$i.svg  -o "$DIR5X/wait-$i.png" > /dev/null
  inkscape -w 56 -h 56  $RAWSVGS/wait-$i.svg  -o "$DIR6X/wait-$i.png" > /dev/null
  inkscape -w 64 -h 64  $RAWSVGS/wait-$i.svg  -o "$DIR7X/wait-$i.png" > /dev/null
  inkscape -w 72 -h 72  $RAWSVGS/wait-$i.svg  -o "$DIR8X/wait-$i.png" > /dev/null
  inkscape -w 80 -h 80  $RAWSVGS/wait-$i.svg  -o "$DIR9X/wait-$i.png" > /dev/null
  inkscape -w 88 -h 88  $RAWSVGS/wait-$i.svg  -o "$DIR10X/wait-$i.png" > /dev/null
  inkscape -w 96 -h 96  $RAWSVGS/wait-$i.svg  -o "$DIR11X/wait-$i.png" > /dev/null

done
echo -e "\033[0KGenerating animated cursor pixmaps for ${THEME} Wait... DONE"

sleep 2s

# Generate cursors
for CUR in src/config/*.cursor; do
  BASENAME=$CUR
  BASENAME=${BASENAME##*/}
  BASENAME=${BASENAME%.*}

  ERR="$( xcursorgen -p build/${THEME} "$CUR" "$OUTPUT/cursors/$BASENAME" 2>&1 )"

  if [[ "$?" -ne "0" ]]; then
    echo "FAIL: $CUR $ERR"
  fi
done

echo -e "Generating cursor theme... DONE"

sleep 1s

# Generate shortcuts
echo -ne "Generating shortcuts...\\r"
while read -r ALIAS ; do
  FROM=${ALIAS% *}
  TO=${ALIAS#* }
  if [ -e "$OUTPUT/cursors/$FROM" ] ; then
    continue
  fi
  ln -sf "$TO" "$OUTPUT/cursors/$FROM"
done < $ALIASES
echo -e "\033[0KGenerating shortcuts... DONE"

# Copy Index theme
echo -ne "Copying Theme Index...\\r"
if ! [ -e "$OUTPUT/$CURSOR" ] ; then
  cp $CURSOR "$OUTPUT/cursor.theme"
  cp $INDEX "$OUTPUT/index.theme"
fi
echo -e "\033[0KCopying Theme Index... DONE"

echo "COMPLETE!"
exit 0
