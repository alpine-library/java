#!/bin/bash
set -e

declare -A aliases
aliases=(
	["8.1"]='8.1 edge'
	["8.0"]='8 latest'
)


which greadlink > /dev/null 2>&1 && cd "$(dirname "$(greadlink -f "$BASH_SOURCE")")" || cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( */ )
versions=( "${versions[@]%/}" )

url='git://github.com/alpine-library/java'
echo '# maintainer: Ekozan <m@3Ko.fr>'

for version in "${versions[@]}"; do

	commit="$(cd "$version" && git log -1 --format='format:%H' -- Dockerfile $(awk 'toupper($1) == "COPY" { for (i = 2; i < NF; i++) { print $i } }' Dockerfile))"

	flavor="${version%%-*}" # "openjdk"
	javaVersion="${version#*-}" # "6-jdk"
	javaType="${javaVersion##*-}" # "jdk"
	javaVersion="${javaVersion%-*}" # "6"

	fullVersion="$(grep -m1 'ENV JAVA_VERSION ' "$version/Dockerfile" | cut -d' ' -f3 | tr '~' '-')"



	bases=( $flavor-$fullVersion )
	if [ "${fullVersion%-*}" != "$fullVersion" ]; then
		bases+=( $flavor-${fullVersion%-*} ) # like "8u40-b09
	fi
	bases+=( $flavor-$javaVersion )
	if [ "$flavor" = "$defaultFlavor" ]; then
		for base in "${bases[@]}"; do
			bases+=( "${base#$flavor-}" )
		done
	fi

	versionAliases=()
	for base in "${bases[@]}"; do
		versionAliases+=( "$base-$javaType" )
		if [ "$javaType" = "$defaultType" ]; then
			versionAliases+=( "$base" )
		fi
	done
	versionAliases+=( ${aliases[$version]} )

	echo
	for va in "${versionAliases[@]}"; do
		echo "$va: ${url}@${commit} $version"
	done
	
done
