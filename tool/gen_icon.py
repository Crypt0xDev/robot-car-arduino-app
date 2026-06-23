"""Genera el icono de la app: un robot original (plano, azul del tema).
Crea:
  assets/icon/robot_icon.png  -> icono completo (fondo azul + robot)  1024x1024
  assets/icon/robot_fg.png    -> robot sobre fondo transparente (adaptive foreground)
"""
import os
from PIL import Image, ImageDraw

AZUL = (21, 101, 192, 255)      # #1565C0
AZUL_OSC = (13, 71, 161, 255)   # #0D47A1
BLANCO = (255, 255, 255, 255)

S = 1024


def dibujar_robot(draw, cx, cy, escala):
    """Dibuja un robot centrado en (cx, cy) con un factor de escala."""
    def e(v):
        return v * escala

    # Antena
    draw.line([(cx, cy - e(255)), (cx, cy - e(170))], fill=BLANCO, width=int(e(24)))
    r = e(34)
    draw.ellipse([cx - r, cy - e(205) - r, cx + r, cy - e(205) + r], fill=BLANCO)

    # Orejas (laterales)
    draw.rounded_rectangle([cx - e(245), cy - e(40), cx - e(205), cy + e(70)],
                           radius=e(16), fill=BLANCO)
    draw.rounded_rectangle([cx + e(205), cy - e(40), cx + e(245), cy + e(70)],
                           radius=e(16), fill=BLANCO)

    # Cabeza
    draw.rounded_rectangle([cx - e(210), cy - e(170), cx + e(210), cy + e(190)],
                           radius=e(60), fill=BLANCO)

    # Ojos
    ro = e(56)
    for ox in (-e(105), e(105)):
        draw.ellipse([cx + ox - ro, cy - e(50) - ro, cx + ox + ro, cy - e(50) + ro],
                     fill=AZUL)
        # brillo
        rb = e(18)
        draw.ellipse([cx + ox - rb + e(18), cy - e(68) - rb, cx + ox + rb + e(18),
                      cy - e(68) + rb], fill=BLANCO)

    # Boca con "dientes"
    draw.rounded_rectangle([cx - e(110), cy + e(60), cx + e(110), cy + e(120)],
                           radius=e(16), fill=AZUL)
    for dx in (-e(55), 0, e(55)):
        draw.line([(cx + dx, cy + e(60)), (cx + dx, cy + e(120))], fill=BLANCO,
                  width=int(e(10)))


def main():
    base = os.path.join(os.path.dirname(__file__), "..", "assets", "icon")
    os.makedirs(base, exist_ok=True)

    # 1) Icono completo: fondo azul redondeado + robot
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle([0, 0, S - 1, S - 1], radius=210, fill=AZUL)
    dibujar_robot(d, S // 2, S // 2 + 10, 1.0)
    img.save(os.path.join(base, "robot_icon.png"))

    # 2) Foreground adaptive: robot mas pequeno, centrado, fondo transparente
    fg = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    df = ImageDraw.Draw(fg)
    dibujar_robot(df, S // 2, S // 2 + 10, 0.62)
    fg.save(os.path.join(base, "robot_fg.png"))

    print("Iconos generados en", os.path.abspath(base))


if __name__ == "__main__":
    main()
