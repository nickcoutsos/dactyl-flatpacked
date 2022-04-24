# dactyl–flatpacked

A reimagined [dactyl](https://github.com/adereth/dactyl-keyboard) using 2D
slotted pieces instead of 3D printing.

![Keyboard](images/v2-rendered.jpg)
![Cutting template](images/v2-template.png)

**Note:** I built this keyboard years ago with code that has since changed
considerably. The current state of the master branch is still a work in progress
and hasn't been tested. I don't have immediate plans to build a new keyboard
from this design in the near future but the refactor and redesign is a fun
project anyway, and hopefully of some use/interest to you.

If you want to see the original code and cutting template look at the tag
`original`.


## The Idea

Use two dimensional pieces of laser cut acrylic, slotted together orthogonally,
to create the Dactyl keyboard shape.

When I started this project the cost to have a Dactyl printed by a third party
seemed prohibitively expensive and the printer I had access to was not up to the
challenge. Neither of these restrictions are true today but this was pretty fun
to work on anyway.


## Recent Changes

This iteration still makes the Dactyl keyboard shape but there are significant
differences:

1. Place column supports on either side of the switch instead of beneath it.
    This requires thinner material but the original 3mm of acrylic was already
    more than thick enough. The current design is 2mm and things seem to fit
    together nicely.
2. Fix the row/column radius calculations to account for keycap height: the
    `mount_width`/`mount_depth` parameters need to reflect the dimensions of the
    keycap at its base in order to get the correct spacing.
3. Construct everything from extruded polygons instead of `hull()`ing and
    `difference()`ing all kinds of geometry. This seems to perform better and
    makes it less weird to try to flatten everything when generating a cutting
    template (which is kind of the whole point anyway).

To simplify the code I've started migrating things over to using the amazing
[BOSL2](https://github.com/revarbat/BOSL2) library.


## See Also

Over time I have seen more designs pop up using similar ideas to build up the
structure of a 3D contoured keyboard using 2D laser cut components. You may be
interested in looking at:

* [Habilis](https://github.com/thblt/habilis) by Thibault Polge
    * Designed in Autodesk Inventor, I think
    * This is the first implementation I saw after my own
    * It seems to have the most in common with the dactyl-flatpacked
    * Pictures available on his reddit posts:
        * [/r/MechanicalKeyboards/comments/cbehge/very_early_preview_my_first_build_a/](https://www.reddit.com/r/MechanicalKeyboards/comments/cbehge/very_early_preview_my_first_build_a/)
        * [/r/MechanicalKeyboards/comments/cm97ey/my_first_build_the_habilis_design_preview_while/](https://www.reddit.com/r/MechanicalKeyboards/comments/cm97ey/my_first_build_the_habilis_design_preview_while/)
        * [/r/MechanicalKeyboards/comments/covxon/first_real_prototype_for_my_split_concave_build/](https://www.reddit.com/r/MechanicalKeyboards/comments/covxon/first_real_prototype_for_my_split_concave_build/)
* [Acrylic 3D KB](https://github.com/kobababa/Acrylic_3D_KB) by Kobakos
    * Designed in Fusion 360
    * I was really impressed by the elegance of this design.
    * It does sacrifice curvature around the Y axis and per-column stagger, but
        I think grouping pairs of columns is a clever compromise and results in
        a much smaller part count.
    * Having fewer and larger pieces would help with assembly and probably makes
        for a less fragile end result.
* [Lasercut modular ergo keyboard with wells](https://www.reddit.com/r/ErgoMechKeyboards/comments/njuay2/second_prototype_of_a_lasercut_modular_ergo/) by [/u/Macone4](https://www.reddit.com/user/Macone4)
    * Designed in Fusion 360
    * Also [the first prototype post](https://www.reddit.com/r/ErgoMechKeyboards/comments/nbbqdz/first_proof_of_concept_of_a_lasercut_modular/)
    * Tighter curvature than the Dactyl, I think
    * First time seeing one of these using wood!
    * Looks to be a similar strategy to the dactyl-flatpacked and Habilis
    * A single support down the center of each column is interesting
        * May allow columns to squeeze in more tightly without interference
        * Looks like this would add to the minimum height due to the extra
            clearance needed underneath the switch
* [Laser cut dactyl](https://www.reddit.com/r/ErgoMechKeyboards/comments/txumq3/laser_cut_dactyl/) by [Rannathrtv](https://www.reddit.com/user/Rannathrtv)
    * Designed in Fusion 360
    * Another wooden design, the end result looks lovely with the burnt edges!
    * Row-based instead of column based, so curvature is around X axis and is
        otherwise ortholinear
    * Far fewer pieces to deal with
    * May have been designed with hotswap sockets in mind
    * Based on images it looks like there is a slight tenting so the row pieces
        don't technically slot in at 90˚. This may not be an issue if everything
        is glued or otherwise held firmly in place.