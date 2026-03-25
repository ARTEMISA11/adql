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
