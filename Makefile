alll: generate

generate:
	@hugo --gc --minify

dev:
	@hugo server -D
