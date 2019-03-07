#!/bin/bash

( cd "$(git rev-parse --show-toplevel)/Analog/Localization" && \
curl 'https://localise.biz/api/export/archive/strings.zip?key=Hn-tsPryPIckbpv547GEAdxICToVJe-C' -o localDict.zip && \
unzip localDict.zip && \
rm localDict.zip && \
rm -rf *.lproj && \
mv -f analog-app-strings-archive/*.lproj . && \
rm -r analog-app-strings-archive && \
cd "$(git rev-parse --show-toplevel)" && \
./swiftgen/bin/swiftgen strings --output Analog/Localization/GeneratedLocalizedStrings.swift --template localizeable Analog/Localization/da-DK.lproj/Localizable.strings --param publicAccess=public)
exit 0
