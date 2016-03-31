# coding=utf-8

# Progetto: SpassoUno

import time
import shutil
from decimal import Decimal

from camera_manager import Camera
from session_manager import SessionManager
from utility import init_key_read, restore_key_read, read_key
from periodic_thread import PeriodicThread

__version__ = '0.1'
__author__ = 'Fabrizio Guglielmino'


class Keys(object):
    UP_KEY = '\x1b[A'       # Decelerate preview
    DOWN_KEY = '\x1b[B'     # Accelerate preview
    SPACE_KEY = ' '         # Take a snapshot
    X_KEY = 'x'             # Delete a frame
    M_KEY = 'm'             # Make video
    G_KEY = 'g'             # Make animated GIF
    Q_KEY = 'q'             # Quit
    D_KEY = 'd'             # Delete session (new session)


class SpassoUno(object):
    _camera = None
    _session_manager = None
    _periodic_thread = None
    _is_running = False
    _frame_delay = 1.0
    DELAY_INCR_STEP = 0.1

    _functions = {}

    def __init__(self, session_manager, camera, periodic_thread):
        try:
            self._old_settings = init_key_read()
        except:
            pass

        self.__map_key_methods()

        self._periodic_thread = periodic_thread
        self._periodic_thread.callback = self.__show_next_frame
        self._periodic_thread.start()

        self._session_manager = session_manager
        self._camera = camera

        self._camera.start_preview()

    def cleanup(self):
        restore_key_read(self._old_settings)
        self._periodic_thread.cancel()

        if self._camera:
            self._camera.stop_preview()
            self._camera.close()

    def run(self):
        self._is_running = True
        while self._is_running:
            self.__process_input()
            time.sleep(0.05)

    def __map_key_methods(self):
        self._functions[Keys.SPACE_KEY] = self.__capture_frame
        self._functions[Keys.X_KEY] = self.__delete_last_frame
        self._functions[Keys.M_KEY] = self.__make_video
        self._functions[Keys.G_KEY] = self.__make_animated_GIF
        self._functions[Keys.UP_KEY] = self.__inc_prev_speed
        self._functions[Keys.DOWN_KEY] = self.__dec_prev_speed
        self._functions[Keys.D_KEY] = self.__delete_cur_session

        self._functions[Keys.Q_KEY] = self.__quit_app

    def __process_input(self):
        key = read_key()

        if key in self._functions:
            self._functions[key]()

    def __quit_app(self):
        self._is_running = False

    def __capture_frame(self):
        self._camera.annotate_text('')
        filename = self._session_manager\
            .current_session\
            .generate_file_name()

        self._camera.capture_to_file(filename)

        self.__show_frame(filename)

    def __inc_prev_speed(self):
        if int(self._frame_delay * 10) > int(self.DELAY_INCR_STEP * 10):
            self._frame_delay -= self.DELAY_INCR_STEP

        self._camera.annotate_text('Inc {0}'.format(self._frame_delay))
        self._periodic_thread.change_period(self._frame_delay)

    def __dec_prev_speed(self):
        self._frame_delay += self.DELAY_INCR_STEP

        self._camera.annotate_text('Dec {0}'.format(self._frame_delay))
        self._periodic_thread.change_period(self._frame_delay)

    def __delete_last_frame(self):
        print "__deleteLastFrame"

    def __make_video(self):
        print "__makeVideo"

    def __make_animated_GIF(self):
        print "__makeAnimatedGIF"

    def __delete_cur_session(self):
        self._periodic_thread.cancel()
        shutil.rmtree(self._session_manager.current_session.session_path)
        self._session_manager.reset_cur_session()
        self._periodic_thread.start()

    def __show_frame(self, image_name):
        return self._camera.show_frame(image_name)

    def __show_next_frame(self):
        img_iter = self._session_manager.current_session.get_img_iterator()
        if img_iter:
            img = next(img_iter)
            if img:
                self.__show_frame(img)
        else:
            self.__show_frame('res/logo.jpg')

if __name__ == '__main__':
    spasso1 = SpassoUno(SessionManager(), Camera(), PeriodicThread())
    spasso1.run()
    spasso1.cleanup()
