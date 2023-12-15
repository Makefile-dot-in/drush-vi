using SDL;

enum Tile {
    AIR, DIRT, GRASS;
}

class Drush.World : Object, View {
    

    public void update (Game g, uint32 tdelta) {
        SDL.Event ev;
        while (g.next_event (out ev)) {
        }
    }
    public void render (Game g) {
        assert_not_reached ();
    }

}