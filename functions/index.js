const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { getMessaging } = require("firebase-admin/messaging");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

exports.sendEventNotification = onDocumentCreated(
    {
        document: "sport/{id}",
        region: "us-central1",
    },
    async (event) => {
      const snapshot = event.data;
      if (!snapshot) {
        console.log("No event data found.");
        return;
      }

      const eventData = snapshot.data();
      const date = eventData.selectedDate.toDate().toLocaleDateString("en-US", {
          weekday: "long",
          year: "numeric",
          month: "long",
          day: "numeric"
      });
      const sportTopic = eventData.sportName;

      const message = {
        notification: {
            title: `New ${eventData.sportName} Event Added! Check it out!`,
            body: `On ${date}`,
        },
        topic: sportTopic,
      };

      try {
        await getMessaging().send(message);
        console.log("Notification sent to topic");
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    }
);

exports.notifyParticipantsOnJoin = onDocumentUpdated(
    {
        document: "sport/{id}",
        region: "us-central1",
    },

    async (event) => {
        const after = event.data.after;
        const before = event.data.before;
         if (!before || !after) {
             console.log("No event data found.");
             return;
         }

         const afterData = after.data();

        const eventId = afterData.id;
        const eventTopic = `event_${eventId}`;
        console.log("Event topic: ", eventTopic);

        const message = {
            notification: {
                title: "New Player Joined!",
                body: `Someone joined your ${afterData.sportName} event!`,
            },
            topic: eventTopic,
        };

        try {
            await getMessaging().send(message);
            console.log(`Notification sent to topic: ${eventTopic}`);
        } catch (error) {
            console.error("Error sending notification:", error);
        }

    }
);