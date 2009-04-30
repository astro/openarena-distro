WGET=wget -c
UNZIP=unzip

DISTRO_VERSION=2009043000
TORRENT_FILE=openarena-distro-$(DISTRO_VERSION).torrrent

.DEFAULT: $(TORRENT_FILE)

$(TORRENT_FILE): DISTRO
	buildtorrent -C -a http://tracker.thepiratebay.org/announce openarena $@

.PHONY: DISTRO
DISTRO: openarena openarena/baseoa/z_am_mappack-a2.pk3 openarena/hh3

clean:
	rm -rf openarena openarena-0.8.1 $(TORRENT_FILE)

.DELETE_ON_ERROR: openarena openarena/hh3


# http://openarena.ws/

openarena: dl/oa081.zip
	$(UNZIP) $<
	rm -rf $@
	mv openarena-0.8.1/ $@

dl/oa081.zip:
	$(WGET) -O $@ http://download.tuxfamily.org/openarena/rel/081/oa081.zip


# http://armageddonman.blogspot.com/2009/03/mi-mappack-para-oa-el-final.html

openarena/baseoa/z_am_mappack-a2.pk3: dl/am_mappack-a2.zip openarena
	$(UNZIP) $< z_am_mappack-a2.pk3
	mv z_am_mappack-a2.pk3 $@

dl/am_mappack-a2.zip:
	$(WGET) -O $@ http://www.onykage.com/files/armageddonman/am_mappack-a2.zip


# http://tarot.telefragged.com/hh3/

HH3_FILES=altars.cfg dmmap-server.cfg hh.cfg \
	  hh3-atmosphere.pk3 hh3-general.pk3 hh3-vm.pk3 \
	  hh3-vm1.pk3 hh3v10_changelog.txt hhmap-server.cfg \
	  items.cfg orig_hh.cfg readme-help.txt

openarena/hh3 : FILES=$(addprefix dl/hh3/, $(HH3_FILES))
openarena/hh3: $(addprefix dl/hh3/, $(HH3_FILES))
	mkdir $@
	cp $(FILES) $@

dl/hh3/% : URL=$(join http://spaceboyz.net/~cosmo/openarena/hh3/, $(patsubst dl/hh3/%, %, $@))
dl/hh3/%:
	$(WGET) -O $@ $(URL)

