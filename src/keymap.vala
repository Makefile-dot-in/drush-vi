using SDL;
using SDL.Input;

public enum Drush.GameKey {
    UNBOUND, UP, DOWN, LEFT, RIGHT, NUM_GAMEKEYS
}

public struct Drush.KeyQuery {
    bool val;
    bool[] pressed;
    uint16 mod;

    public KeyQuery gamekey(GameKey gk) {
        val = val && gk == this.gk;
        return this;
    }

    public KeyQuery modifiers(uint16 mod) {
        val = val && (mod & ~this.mod) == 0;
        return this;
    }

    public bool ask() {
        return val;
    }
}

public class Drush.Keymap {
    private GameKey[] keymap = new GameKey[(int)Scancode.NUM_SCANCODES];
    private bool[] pressed = new bool[(int)GameKey.NUM_GAMEKEYS+1];

    public Keymap() {
        for (int i = 0; i < keymap.length; i++)
            keymap[i] = GameKey.UNBOUND;
    }

    public Keymap add(Scancode sc, GameKey gk) {
        keymap[(int)sc] = gk;
        return this;
    }

    public bool is_pressed(GameKey gk) {
        return pressed[(int)gk];
    }

    public void process_event(ref Event ev) {
        switch (ev.type) {
            case EventType.KEYDOWN:
                pressed[(int)keymap[(int)ev.key.keysym.scancode]] = true;
                break;
            case EventType.KEYUP:
                pressed[(int)keymap[(int)ev.key.keysym.scancode]] = false;
                break;
            default:
                break;
        }
    }

    public KeyQuery query() {
        return KeyQuery() {
            val = true,
            
        };
    }
}