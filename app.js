const { createApp } = Vue;

createApp({
    data() {
        return {
            equipments: [
                {
                    id: 'etuve1',
                    name: 'Étuve 1',
                    description: 'Étuve thermique - Température 20-80°C',
                    quantity: 1,
                    specs: 'Capacité: 50L, Précision: ±2°C'
                },
                {
                    id: 'etuve2',
                    name: 'Étuve 2',
                    description: 'Étuve thermique - Température 20-80°C',
                    quantity: 1,
                    specs: 'Capacité: 50L, Précision: ±2°C'
                },
                {
                    id: 'etuve3',
                    name: 'Étuve 3',
                    description: 'Étuve thermique - Température 20-80°C',
                    quantity: 1,
                    specs: 'Capacité: 50L, Précision: ±2°C'
                },
                {
                    id: 'etuve4',
                    name: 'Étuve 4',
                    description: 'Étuve thermique - Température 20-80°C',
                    quantity: 1,
                    specs: 'Capacité: 50L, Précision: ±2°C'
                },
                {
                    id: 'etuve5',
                    name: 'Étuve 5',
                    description: 'Étuve thermique - Température 20-80°C',
                    quantity: 1,
                    specs: 'Capacité: 50L, Précision: ±2°C'
                },
                {
                    id: 'chambrerf',
                    name: 'Chambre RF',
                    description: 'Chambre de test radioélectrique',
                    quantity: 1,
                    specs: 'Fréquences: 80MHz - 6GHz, Isolation: >60dB'
                },
                {
                    id: 'banc1',
                    name: 'Banc de Test Automatique 1',
                    description: 'Banc de test automatisé pour composants électroniques',
                    quantity: 1,
                    specs: 'Débit: 100kHz - 10MHz, 8 voies de test'
                },
                {
                    id: 'banc2',
                    name: 'Banc de Test Automatique 2',
                    description: 'Banc de test automatisé pour composants électroniques',
                    quantity: 1,
                    specs: 'Débit: 100kHz - 10MHz, 8 voies de test'
                },
                {
                    id: 'banc3',
                    name: 'Banc de Test Automatique 3',
                    description: 'Banc de test automatisé pour composants électroniques',
                    quantity: 1,
                    specs: 'Débit: 100kHz - 10MHz, 8 voies de test'
                }
            ],
            reservations: [],
            newReservation: {
                equipmentId: '',
                date: '',
                startTime: '',
                endTime: '',
                userName: '',
                userEmail: '',
                notes: ''
            },
            timeSlots: [
                '08:00', '09:00', '10:00', '11:00', '12:00',
                '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'
            ],
            message: '',
            messageType: '',
            filterStatus: 'all',
            filterEquipmentId: ''
        };
    },
    computed: {
        minDate() {
            const today = new Date();
            return today.toISOString().split('T')[0];
        }
    },
    methods: {
        makeReservation() {
            // Validation
            if (!this.newReservation.equipmentId || !this.newReservation.date ||
                !this.newReservation.startTime || !this.newReservation.endTime ||
                !this.newReservation.userName || !this.newReservation.userEmail) {
                this.setMessage('Veuillez remplir tous les champs requis.', 'error');
                return;
            }

            // Vérifier que l'heure de fin est après l'heure de début
            if (this.newReservation.startTime >= this.newReservation.endTime) {
                this.setMessage('L\'heure de fin doit être après l\'heure de début.', 'error');
                return;
            }

            // Vérifier la disponibilité
            if (!this.isAvailable()) {
                this.setMessage('L\'équipement n\'est pas disponible pour cette plage horaire.', 'error');
                return;
            }

            // Vérifier que la date n'est pas dans le passé
            const selectedDate = new Date(this.newReservation.date);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            if (selectedDate < today) {
                this.setMessage('Impossible de réserver pour une date passée.', 'error');
                return;
            }

            // Créer la réservation
            const reservation = {
                id: this.generateId(),
                equipmentId: this.newReservation.equipmentId,
                equipmentName: this.getEquipmentName(this.newReservation.equipmentId),
                date: this.newReservation.date,
                startTime: this.newReservation.startTime,
                endTime: this.newReservation.endTime,
                userName: this.newReservation.userName,
                userEmail: this.newReservation.userEmail,
                notes: this.newReservation.notes,
                createdAt: new Date().toISOString(),
                status: 'À venir'
            };

            this.reservations.push(reservation);
            this.saveToLocalStorage();
            this.setMessage('✓ Réservation effectuée avec succès !', 'success');
            this.resetForm();
        },

        isAvailable() {
            const { equipmentId, date, startTime, endTime } = this.newReservation;

            const conflicts = this.reservations.filter(res => {
                return res.equipmentId === equipmentId &&
                       res.date === date &&
                       res.status === 'À venir' &&
                       this.timesOverlap(startTime, endTime, res.startTime, res.endTime);
            });

            return conflicts.length === 0;
        },

        timesOverlap(start1, end1, start2, end2) {
            return start1 < end2 && end1 > start2;
        },

        cancelReservation(id) {
            if (confirm('Êtes-vous sûr de vouloir annuler cette réservation ?')) {
                const index = this.reservations.findIndex(r => r.id === id);
                if (index !== -1) {
                    this.reservations.splice(index, 1);
                    this.saveToLocalStorage();
                    this.setMessage('✓ Réservation annulée.', 'success');
                }
            }
        },

        getAvailableCount(equipmentId) {
            const equipment = this.equipments.find(e => e.id === equipmentId);
            if (!equipment) return 0;

            const today = new Date().toISOString().split('T')[0];
            const activeReservations = this.reservations.filter(res => {
                return res.equipmentId === equipmentId &&
                       res.date === today &&
                       res.status === 'À venir';
            });

            return Math.max(0, equipment.quantity - activeReservations.length);
        },

        getEquipmentName(equipmentId) {
            const equipment = this.equipments.find(e => e.id === equipmentId);
            return equipment ? equipment.name : 'Équipement inconnu';
        },

        getStatusClass(equipment) {
            const available = this.getAvailableCount(equipment.id);
            if (available === 0) return 'unavailable';
            if (available < equipment.quantity * 0.33) return 'limited';
            return 'available';
        },

        getAvailableEndTimes() {
            if (!this.newReservation.startTime) return this.timeSlots;
            const startIndex = this.timeSlots.indexOf(this.newReservation.startTime);
            return this.timeSlots.slice(startIndex + 1);
        },

        getUpcomingDays() {
            const days = [];
            const today = new Date();
            for (let i = 0; i < 14; i++) {
                const date = new Date(today);
                date.setDate(date.getDate() + i);
                days.push(date.toISOString().split('T')[0]);
            }
            return days;
        },

        getReservationsForDay(day) {
            const filteredByDay = this.reservations.filter(res => res.date === day);
            if (this.filterEquipmentId) {
                return filteredByDay.filter(res => res.equipmentId === this.filterEquipmentId);
            }
            return filteredByDay;
        },

        getUpcomingReservations() {
            const today = new Date().toISOString().split('T')[0];
            return this.reservations.filter(res => res.date >= today && res.status === 'À venir');
        },

        getPastReservations() {
            const today = new Date().toISOString().split('T')[0];
            return this.reservations.filter(res => res.date < today || res.status === 'Annulée');
        },

        getFilteredReservations() {
            if (this.filterStatus === 'upcoming') {
                return this.getUpcomingReservations();
            } else if (this.filterStatus === 'past') {
                return this.getPastReservations();
            }
            return this.reservations;
        },

        formatDate(dateString) {
            const date = new Date(dateString + 'T00:00:00');
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            return date.toLocaleDateString('fr-FR', options);
        },

        setMessage(text, type) {
            this.message = text;
            this.messageType = type;
            setTimeout(() => {
                this.message = '';
            }, 4000);
        },

        resetForm() {
            this.newReservation = {
                equipmentId: '',
                date: '',
                startTime: '',
                endTime: '',
                userName: '',
                userEmail: '',
                notes: ''
            };
        },

        generateId() {
            return 'res_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
        },

        saveToLocalStorage() {
            localStorage.setItem('reservations', JSON.stringify(this.reservations));
        },

        loadFromLocalStorage() {
            const saved = localStorage.getItem('reservations');
            if (saved) {
                try {
                    this.reservations = JSON.parse(saved);
                } catch (e) {
                    console.error('Erreur lors du chargement des réservations:', e);
                }
            }
        }
    },
    mounted() {
        this.loadFromLocalStorage();
    }
}).mount('#app');
