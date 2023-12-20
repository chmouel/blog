alll: generate

generate:
	@hugo --gc --minify

dev:
	@(hugo server -D ) & \
	if type -p xdg-open 3>/dev/null >/dev/null; then \
		xdg-open http://localhost:1313; \
	elif type -p open 2>/dev/null >/dev/null; then \
		open http://localhost:1313; \
	fi

theme-update:
	@git submodule update --remote --merge

theme-checkout:
	@git submodule update --init --recursive
