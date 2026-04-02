const express = require('express');
const path = require('path');
const app = express();

// Configuration du port
const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0';

// Middleware
app.use(express.static(path.join(__dirname, '.')));

// Route de health check
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Route pour la page principale
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Route catch-all pour servir index.html (SPA support)
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Gestion des erreurs
app.use((err, req, res, next) => {
    console.error('❌ Erreur:', err.message);
    res.status(500).json({ error: 'Erreur serveur interne' });
});

// Démarrer le serveur
const server = app.listen(PORT, HOST, () => {
    console.log(`✅ Serveur démarré sur ${HOST}:${PORT}`);
    console.log(`🌐 Accédez à l'application sur http://localhost:${PORT}`);
    console.log(`💚 Health check disponible sur http://localhost:${PORT}/health`);
});

// Gestion des signaux de graceful shutdown
process.on('SIGTERM', () => {
    console.log('📌 Signal SIGTERM reçu, arrêt gracieux...');
    server.close(() => {
        console.log('🛑 Serveur arrêté');
        process.exit(0);
    });
    // Force l'arrêt après 10 secondes
    setTimeout(() => {
        console.error('⚠️ Arrêt forcé après timeout');
        process.exit(1);
    }, 10000);
});

process.on('SIGINT', () => {
    console.log('📌 Signal SIGINT reçu, arrêt gracieux...');
    server.close(() => {
        console.log('🛑 Serveur arrêté');
        process.exit(0);
    });
});

// Gestion des erreurs non attrapées
process.on('uncaughtException', (err) => {
    console.error('❌ Exception non attrapée:', err);
    process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('❌ Promise rejetée non gérée:', reason);
    process.exit(1);
});
