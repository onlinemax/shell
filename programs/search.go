package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type Options struct {
	theme  string
	search string
	size   int
}

func parseArgs() Options {
	var option = Options{theme: "", search: ""}
	for i, arg := range os.Args {
		if i == 0 {
			continue
		}
		if os.Args[i-1] == "--theme" || os.Args[i-1] == "-t" {
			option.theme = arg
		}
		if os.Args[i-1] == "--search" || os.Args[i-1] == "-s" {
			option.search = arg
		}
		if os.Args[i-1] == "--size" || os.Args[i-1] == "-i" {
			size, err := strconv.Atoi(arg)
			if err != nil {
				log.Fatal("Could not parse size ensure it's an int")
			}
			option.size = size
		}
	}
	return option
}

type Group = map[string]string

func parseDesktopEntry(filename string) (map[string]Group, error) {
	keyRegex, err := regexp.Compile(`[a-zA-z0-9-]`)

	if err != nil {
		log.Fatal("Could not compile regex")
	}

	bytes, err := os.ReadFile(filename)
	var content = string(bytes)
	groups := make(map[string]Group)
	current_group := ""
	if err != nil {
		return nil, err
	}

	for _, line := range strings.Split(content, "\n") {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "#") || line == "" {
			continue
		}

		if strings.HasPrefix(line, "[") && strings.HasSuffix(line, "]") {
			line, _ = strings.CutSuffix(line, "]")
			line, _ = strings.CutPrefix(line, "[")
			current_group = line
			groups[current_group] = make(Group)
			continue
		}

		if key, value, found := strings.Cut(line, "="); found {
			if !keyRegex.MatchString(key) {
				err = fmt.Errorf("ParseError Invalid key: %v ", key)
				return nil, err
			}
			if current_group == "" {
				err = fmt.Errorf("Missing group for key %v and value %v", key, value)
				return nil, err
			}
			groups[current_group][key] = value
			continue
		}
		err = fmt.Errorf("ParseError line %v could not be parsed", line)
		return nil, err
	}

	return groups, nil
}
func display_groups(groups *map[string]Group) {
	for group_name, group := range *groups {
		fmt.Println(group_name, ":")
		for key, value := range group {
			fmt.Println(key, ":", value)
		}
		fmt.Println()
	}
}
func themeDirectories(theme string) {
	dirs := os.Getenv("XDG_DATA_DIRS")
	fmt.Println(strings.Split(dirs, ":"))

}
func main() {
	options := parseArgs()
	if options.search == "" || options.size == 0 {
		log.Fatal("Missing required arguments -i -s")
	}
	if options.theme != "" {
	}
	themeDirectories("hicolor")
}
