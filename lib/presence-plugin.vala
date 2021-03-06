/*
 * Copyright (c) 2015 gnome-pomodoro contributors
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors: Kamil Prusko <kamilprusko@gmail.com>
 */

using GLib;


public abstract class Pomodoro.PresencePlugin : Pomodoro.Plugin
{
    protected GLib.Settings global_settings;
    protected GLib.Settings settings;

//    public PresencePlugin ()
    construct
    {
        this.global_settings = Pomodoro.get_settings ()
                                       .get_child ("preferences");

        if (this.name != null) {
            this.settings = new GLib.Settings.with_path (
                            "org.gnome.pomodoro.plugins." + this.name,
                            "/org/gnome/pomodoro/plugins/" + this.name + "/");
        }
    }

    public bool has_custom_status ()
    {
        return (this.settings != null &&
                this.settings.get_boolean ("set-custom-status"));
    }

    public Pomodoro.PresenceStatus get_default_status (Pomodoro.State timer_state)
    {
        var settings = this.has_custom_status ()
                                       ? this.settings
                                       : this.global_settings;

        var settings_key = timer_state == State.POMODORO
                                       ? "presence-during-pomodoro"
                                       : "presence-during-break";

        return string_to_presence_status (settings.get_string (settings_key));
    }    

    public abstract async void set_status (Pomodoro.PresenceStatus status);
}
