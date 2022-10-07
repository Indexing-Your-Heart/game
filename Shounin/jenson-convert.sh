#!/bin/sh

# jenson-convert.sh
# Copyright (C) 2022 Marquis Kurt <software@marquiskurt.net>
# This file is part of Indexing Your Heart.
#
# Indexing Your Heart is non-violent software: you can use, redistribute,
# and/or modify it under the terms of the CNPLv7 as found in the LICENSE file
# in the source code root directory or at
# <https://git.pixie.town/thufie/npl-builder>.
#
# Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted
# by applicable law. See the CNPL for details.

echo "Converting Chapter 1..."
marteau jenson Story\ Source/ch01.md \
    Assets/Story/Base.lproj/ch01-mise-en-abyme.jenson \
    --chapter-name "Mise en Abyme"
echo "Done."

echo "Converting Chapter 2..."
marteau jenson Story\ Source/ch02.md \
    Assets/Story/Base.lproj/ch02-le-marteau-timide.jenson \
    --chapter-name "Le Marteau Timide"
echo "Done."

echo "Converting Chapter 3..."
marteau jenson Story\ Source/ch03.md \
    Assets/Story/Base.lproj/ch03-ecouter-la-vague.jenson \
    --chapter-name "Écouter La Vague"
echo "Done."

echo "Converting Chapter 4..."
marteau jenson Story\ Source/ch04.md \
    Assets/Story/Base.lproj/ch04-la-reveuse-sentimental.jenson \
    --chapter-name "La Rêveuse Sentimental"
echo "Done."

echo "Converting Chapter 5..."
marteau jenson Story\ Source/ch05.md \
    Assets/Story/Base.lproj/ch05-la-lumiere-sombre.jenson \
    --chapter-name "La Lumière Sombre"
echo "Done."

echo "Converting Chapter 6..."
marteau jenson Story\ Source/ch06.md \
    Assets/Story/Base.lproj/ch06-les-conseils-pour-les-jeunes.jenson \
    --chapter-name "Les Conseils pour les Jeunes dans le Cœur"
echo "Done."

echo "Converting Chapter 7..."
marteau jenson Story\ Source/ch07.md \
    Assets/Story/Base.lproj/ch07-changer-de-vie.jenson \
    --chapter-name "Changer de Vie"
echo "Done."

echo "Converting Epilogue..."
marteau jenson Story\ Source/epilogue.md \
    Assets/Story/Base.lproj/epilogue.jenson \
    --chapter-name "Epilogue"
echo "Done."
