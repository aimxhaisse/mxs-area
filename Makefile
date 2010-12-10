all:	clean
	jekyll

clean:
	cp -R _site/static /tmp/
	rm -rf _site/*
	mv /tmp/static _site/

