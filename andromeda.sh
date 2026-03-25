echo = "Iniciamos proceso"

# Guardamos la consulta pura.
ADQL="SELECT TOP 2000 RA_ICRS, DE_ICRS, Gmag FROM \"I/355/gaiadr3\" WHERE Gmag < 16 AND 1=CONTAINS(POINT('ICRS', RA_ICRS, DE_ICRS), CIRCLE('ICRS', 10.68, 41.26, 3.0))"

# Reemplazamos los espacios por '+' usando 'sed' para que la URL no se rompa en internet
URL_ADQL=$(echo $ADQL | sed 's/ /+/g')
# Definimos el Endpoint base de VizieR
TAP_URL="https://tapvizier.cds.unistra.fr/TAPVizieR/tap/sync?request=doQuery&lang=ADQL&format=csv&query="

# Ejecutamos wget combinando el Endpoint y la consulta codificada
wget -q -O andromeda.csv "$TAP_URL$URL_ADQL"
echo "Descarga finalizada: andromeda.csv"

echo " Generando script de visualización en Python..."
cat << 'EOF' > graficar_mapa.py
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('andromeda.csv')

plt.figure(figsize=(8,8))
plt.style.use('dark_background')
plt.scatter(df['RA_ICRS'], df['DE_ICRS'], s=(20-df['Gmag'])**2, color='azure', alpha=0.8)
plt.gca().invert_xaxis()
plt.title('Mapa Estelar: Andromeda (Cone Search 3 grados)')
plt.xlabel('Ascensión Recta (Grados)')
plt.ylabel('Declinación (Grados)')
plt.savefig('mapa_andromeda.png')
print("Imagen mapa_pleyades.png generada.")
EOF

echo " Ejecutando Python..."
python3 graficar_mapa.py

echo " Guardando en Control de Versiones... "
echo "andromeda.csv" > .gitignore
git add andromeda.sh graficar_mapa.py andromeda.png .gitignore

git commit -m "Pipeline automático: Cone Search y Mapeo de andromeda"
echo "¡Proceso 100% reproducible completado!"
