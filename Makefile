all:	clean
	jekyll

clean:
	rm -rf _site/*
	cp -R static _site/

