alll: sync

sync:
	@hugo --gc --minify && rsync -aPuz public/ kodi:/media/bigdisk/www/blog/ --exclude wp-content/uploads/
