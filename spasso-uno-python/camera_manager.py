import io
from PIL import Image

from picamera.array import PiRGBArray
from picamera import PiCamera

from picamera.renderers import PiOverlayRenderer


class Camera(object):
    _overlay_rederer = None

    def __init__(self):
        self._camera = PiCamera()

        self._camera.framerate = 24

        self._camera.sharpness = 0
        self._camera.contrast = 0
        self._camera.brightness = 50

        self._camera.saturation = 0
        self._camera.ISO = 0
        self._camera.video_stabilization = False
        self._camera.exposure_compensation = 0
        self._camera.exposure_mode = 'auto'
        self._camera.meter_mode = 'matrix'
        self._camera.awb_mode = 'auto'
        self._camera.image_effect = 'none'
        self._camera.image_effect = 'none'

        self._camera.rotation = 0
        self._camera.hflip = True
        self._camera.vflip = False

        w = self._camera.resolution[0] / 2
        h = self._camera.resolution[1]
        self._camera.resolution = (w, h)

    def annotate_text(self, text):
        self._camera.annotate_text = text

    def start_preview(self):
        w = self._camera.resolution[0]
        h = self._camera.resolution[1]
        self._camera.start_preview(fullscreen=False, window=(0, 0, w, h))

    def stop_preview(self):
        self._camera.stop_preview()

    def close(self):
        self._camera.close()

    def capture_to_file(self, file_name):
        stream = io.BytesIO()
        self._camera.capture(
            stream, use_video_port=False, format='jpeg')
        frame = Image.open(stream)
        frame.save(file_name, "JPEG")

    def show_frame(self, image_name):
        img = Image.open(image_name)

        pad = Image.new('RGB', (
            (((self._camera.resolution[0] * 2) + 31) // 32) * 32,
            ((img.size[1] + 15) // 16) * 16,
        ))

        pad.paste(img, (self._camera.resolution[0], 0))
        source = pad.tobytes()
        if not self._overlay_rederer:
            self._overlay_rederer = self._camera.add_overlay(pad.tobytes(), size=(self._camera.resolution[0] * 2,
                                                                                  img.size[1]))
        else:
            self._overlay_rederer.update(source)
