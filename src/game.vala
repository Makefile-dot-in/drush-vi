using SDL;
using SDL.Video;
using Gee;

public errordomain Drush.Error {
    SDL_ERROR, GAME_NO_VIEWS;

    internal static void throw_sdlerr() throws Drush.Error {
        throw new Drush.Error.SDL_ERROR(SDL.get_error());
    }
}


public interface Drush.View : Object {
    public abstract void update(Game g, uint32 tdelta);
    public abstract void render(Game g);
}

public class Drush.Game : Object {
    const string GAME_NAME = "Meow";
    public const int WIDTH = 600;
    public const int HEIGHT = 400;
    const int FRAME_PERIOD_US = 1000000/60;

    private Window _win;
    private Renderer _rend;
    public Window win { get { return _win; } }
    public Renderer rend { get { return _rend; } }

    private bool running = false;
    private View[] view_stack = {};

    public Keymap keymap { get; default = new Keymap(); }

    public Game() {
    }

    public void init() throws Drush.Error {
        SDL.init(InitFlag.VIDEO);
        int result = Renderer.create_with_window(
            Game.WIDTH,  Game.HEIGHT, 0,
            out this._win, out this._rend
        );

        if (result < 0) Drush.Error.throw_sdlerr();
    }

    public void run() throws Drush.Error {
        running = true;
        uint32 tdelta = 0;
        while (running) {
            int64 loop_start_time = GLib.get_monotonic_time();
            if (this.view_stack.length == 0) {
                throw new Drush.Error.GAME_NO_VIEWS("run() called but no views passed");
            }
            view_stack[view_stack.length-1].update(this, tdelta);
            view_stack[view_stack.length-1].render(this);

            int64 loop_end_time = GLib.get_monotonic_time();

            ulong wait_time = (ulong) int64.max(
                0,
                (loop_start_time + FRAME_PERIOD_US) - loop_end_time
            );
            GLib.Thread.usleep(wait_time);
            tdelta = (uint32) int64.min(
                (GLib.get_monotonic_time() - loop_start_time)/1000,
                uint32.MIN
            );
        }
    }

    public void close_view() {
        this.view_stack.resize(this.view_stack.length-1);
    }

    public void open_view(View v) {
        this.view_stack += v;
    }

    public bool next_event(out Event ev) {
        bool ev_present = Event.poll(out ev) == 1;
        if (ev_present) keymap.process_event(ref ev);
        return ev_present;
    }

}
