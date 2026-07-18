import 'package:aidme/pages/quiz_page.dart';

final List<String> quizCategoryNames = [
  'Emergency Response',
  'Wound & Injury Care',
  'Environmental Emergencies',
  'Advanced First Aid',
  'Pediatric & Special Cases',
];

final List<List<FirstAidQuiz>> quizSets = [
  // Set 1 - Emergency Response
  const [
    FirstAidQuiz(
      questionEn: "What is the very first step if you find someone unconscious?",
      optionsEn: [
        "Give them a glass of water",
        "Check response and call emergency (108/112)",
        "Start chest compressions immediately",
        "Slap their face to wake them up"
      ],
      answerIndex: 1,
      explanationEn: "Always check for response and call emergency services before starting any first aid steps to ensure medical help is on the way.",
    ),
    FirstAidQuiz(
      questionEn: "What is the best immediate action for a minor burn?",
      optionsEn: [
        "Apply butter or cooking oil to the burn",
        "Cool the burn with cool running water for 20 minutes",
        "Rub ice directly on the blistered skin",
        "Cover it with a tight woollen cloth"
      ],
      answerIndex: 1,
      explanationEn: "Cool, running tap water for 20 minutes is the recommended first aid. Never use ice, butter, or oil as they can damage tissues or trap heat.",
    ),
    FirstAidQuiz(
      questionEn: "If someone is choking and cannot speak, what should you do?",
      optionsEn: [
        "Give 5 back blows followed by 5 abdominal thrusts (Heimlich)",
        "Make them drink milk or warm water",
        "Forcefully reach into their throat to pull the object out",
        "Tell them to lie down and rest"
      ],
      answerIndex: 0,
      explanationEn: "Alternating between 5 back blows and 5 abdominal thrusts creates high pressure to dislodge the stuck object safely.",
    ),
    FirstAidQuiz(
      questionEn: "What is the correct action if you suspect a fractured bone?",
      optionsEn: [
        "Try to pull or push the bone back into place",
        "Immobilize the area, apply wrapped ice, and seek medical help",
        "Massage the area with hot oil to reduce pain",
        "Ask the person to walk or move it to check if it's broken"
      ],
      answerIndex: 1,
      explanationEn: "Never try to straighten or move a fractured bone. Immobilization prevents further nerve, muscle, and vascular damage.",
    ),
    FirstAidQuiz(
      questionEn: "How do you treat a severe bleeding wound?",
      optionsEn: [
        "Apply direct pressure with a clean cloth and elevate the wound",
        "Wash it with soap and warm water immediately",
        "Remove the embedded object causing the bleeding",
        "Leave it open to let the blood clot"
      ],
      answerIndex: 0,
      explanationEn: "Applying firm direct pressure and elevating the wound above the heart (if possible) is the fastest way to stop severe bleeding.",
    ),
    FirstAidQuiz(
      questionEn: "What should you do if a person is having a seizure?",
      optionsEn: [
        "Hold them down firmly to stop the shaking",
        "Put a spoon in their mouth so they don't bite their tongue",
        "Clear the area of hard objects and cushion their head",
        "Splash cold water on their face"
      ],
      answerIndex: 2,
      explanationEn: "Never restrain them or put objects in their mouth. Clear the area to prevent injury and let the seizure run its course.",
    ),
    FirstAidQuiz(
      questionEn: "What is the proper compression-to-breath ratio for CPR on an adult?",
      optionsEn: [
        "15 compressions to 2 breaths",
        "30 compressions to 2 breaths",
        "50 compressions to 5 breaths",
        "Just give breaths, no compressions"
      ],
      answerIndex: 1,
      explanationEn: "The standard CPR ratio for adults is 30 chest compressions followed by 2 rescue breaths.",
    ),
    FirstAidQuiz(
      questionEn: "How deep should chest compressions be for an adult during CPR?",
      optionsEn: [
        "At least 2 inches (5 cm)",
        "About 1 inch (2.5 cm)",
        "Half an inch (1 cm)",
        "As deep as possible until you hear a crack"
      ],
      answerIndex: 0,
      explanationEn: "Compressions must be deep enough (at least 2 inches) to pump blood effectively from the heart.",
    ),
    FirstAidQuiz(
      questionEn: "What is the first step when using an AED (Automated External Defibrillator)?",
      optionsEn: [
        "Attach the pads to the chest",
        "Turn the AED on",
        "Press the shock button",
        "Check for a pulse"
      ],
      answerIndex: 1,
      explanationEn: "The very first step is to turn the AED on. Once on, the machine provides voice prompts guiding you through all the next steps.",
    ),
    FirstAidQuiz(
      questionEn: "What should you do if someone faints?",
      optionsEn: [
        "Prop them up in a sitting position immediately",
        "Lay them flat on their back and elevate their legs",
        "Slap their cheeks vigorously",
        "Make them drink a sugary drink while unconscious"
      ],
      answerIndex: 1,
      explanationEn: "Laying them flat and elevating their legs helps restore blood flow to the brain. Never give food or drink to an unconscious person.",
    ),
  ],
  // Set 2
  const [
    FirstAidQuiz(
      questionEn: "How do you treat a nosebleed?",
      optionsEn: [
        "Lean head backwards and pinch the nose",
        "Lean head forwards and pinch the soft part of the nose",
        "Lie down flat on the back",
        "Blow the nose vigorously to clear the blood"
      ],
      answerIndex: 1,
      explanationEn: "Leaning forward prevents blood from draining down the throat, which can cause choking or vomiting. Pinching the soft part applies pressure.",
    ),
    FirstAidQuiz(
      questionEn: "What is the sign of a severe allergic reaction (Anaphylaxis)?",
      optionsEn: [
        "A mild rash on the arm",
        "Swelling of the lips/throat and difficulty breathing",
        "A sudden headache",
        "Sneezing twice"
      ],
      answerIndex: 1,
      explanationEn: "Swelling of the airway and difficulty breathing are life-threatening signs of anaphylaxis requiring an immediate EpiPen and emergency help.",
    ),
    FirstAidQuiz(
      questionEn: "What should you do for a bee sting if the stinger is still in the skin?",
      optionsEn: [
        "Squeeze the skin to pop it out",
        "Scrape it away with a flat edge (like a credit card)",
        "Leave it there until it falls out naturally",
        "Burn it off with a match"
      ],
      answerIndex: 1,
      explanationEn: "Scraping avoids squeezing the venom sac at the end of the stinger, which would inject more venom into the skin.",
    ),
    FirstAidQuiz(
      questionEn: "Which of the following is a symptom of heatstroke?",
      optionsEn: [
        "Profuse sweating and pale, clammy skin",
        "Hot, red, dry skin and confusion/unconsciousness",
        "Shivering and blue lips",
        "Sneezing and coughing"
      ],
      answerIndex: 1,
      explanationEn: "Heatstroke causes the body to stop sweating entirely. The skin becomes red, hot, and dry, and it is a medical emergency.",
    ),
    FirstAidQuiz(
      questionEn: "If a person is bitten by a snake, you should:",
      optionsEn: [
        "Suck the venom out with your mouth",
        "Apply a tight tourniquet above the bite",
        "Keep the person calm, immobilized, and seek immediate medical help",
        "Cut an X over the bite mark to let it bleed out"
      ],
      answerIndex: 2,
      explanationEn: "Cutting, sucking, or using a tourniquet can cause severe tissue damage. Keep them calm and still to slow the spread of venom.",
    ),
    FirstAidQuiz(
      questionEn: "What is the correct treatment for a sprained ankle?",
      optionsEn: [
        "R.I.C.E. (Rest, Ice, Compression, Elevation)",
        "Apply a heat pack immediately",
        "Walk on it to loosen the joints",
        "Vigorously massage the swollen area"
      ],
      answerIndex: 0,
      explanationEn: "R.I.C.E. helps reduce swelling and pain in the first 48 hours. Heat can increase swelling if applied too early.",
    ),
    FirstAidQuiz(
      questionEn: "What should you do if a tooth is knocked out?",
      optionsEn: [
        "Wash it vigorously with soap and throw it away",
        "Store it in milk or saliva and rush to a dentist",
        "Wrap it in a dry tissue",
        "Keep it in warm water"
      ],
      answerIndex: 1,
      explanationEn: "Milk or saliva helps preserve the root cells. A dentist might be able to reimplant it if you arrive within 30-60 minutes.",
    ),
    FirstAidQuiz(
      questionEn: "A person with low blood sugar (Hypoglycemia) who is awake needs:",
      optionsEn: [
        "A shot of insulin",
        "A sugary drink or glucose tablets",
        "A large glass of plain water",
        "To sleep it off"
      ],
      answerIndex: 1,
      explanationEn: "Consuming fast-acting carbohydrates like a sugary drink rapidly raises their blood sugar back to a safe level.",
    ),
    FirstAidQuiz(
      questionEn: "How do you assist someone having an asthma attack?",
      optionsEn: [
        "Make them lie flat on the floor",
        "Help them use their inhaler and sit them comfortably upright",
        "Have them breathe into a paper bag",
        "Give them a cup of strong coffee"
      ],
      answerIndex: 1,
      explanationEn: "Sitting upright opens the airways. An inhaler (usually blue) relaxes the airway muscles, making breathing easier.",
    ),
    FirstAidQuiz(
      questionEn: "What does the 'C' in the ABCs of first aid stand for?",
      optionsEn: [
        "Consciousness",
        "Circulation",
        "Care",
        "Chest"
      ],
      answerIndex: 1,
      explanationEn: "ABC stands for Airway, Breathing, and Circulation—the critical functions to check during an emergency.",
    ),
  ],
  // Set 3
  const [
    FirstAidQuiz(
      questionEn: "If someone spills a hazardous chemical on their skin, you should:",
      optionsEn: [
        "Wipe it off with a dry towel",
        "Flush the area with large amounts of cool water for at least 20 minutes",
        "Neutralize it with vinegar or baking soda",
        "Cover it with a tight bandage"
      ],
      answerIndex: 1,
      explanationEn: "Flushing with water dilutes and removes the chemical. Never attempt to neutralize it, as the chemical reaction can cause more heat and burns.",
    ),
    FirstAidQuiz(
      questionEn: "What is a common sign of a heart attack?",
      optionsEn: [
        "Sudden weakness on one side of the face",
        "Crushing chest pain radiating to the jaw or left arm",
        "A sharp pain in the big toe",
        "Excessive sneezing"
      ],
      answerIndex: 1,
      explanationEn: "Chest pain that radiates to the arm, jaw, or back, along with shortness of breath and sweating, are classic heart attack symptoms.",
    ),
    FirstAidQuiz(
      questionEn: "What is a common sign of a stroke?",
      optionsEn: [
        "F.A.S.T. (Face drooping, Arm weakness, Speech difficulty, Time to call 911/108)",
        "A sudden rash across the chest",
        "Bleeding from the nose",
        "Pain in the lower abdomen"
      ],
      answerIndex: 0,
      explanationEn: "The F.A.S.T. acronym is the most effective way to identify a stroke. Immediate medical help is crucial to minimize brain damage.",
    ),
    FirstAidQuiz(
      questionEn: "If a person is hyperventilating due to panic, you should NOT:",
      optionsEn: [
        "Have them breathe into a paper bag",
        "Encourage them to take slow, deep breaths",
        "Reassure them calmly",
        "Help them match their breathing to yours"
      ],
      answerIndex: 0,
      explanationEn: "Breathing into a paper bag is no longer recommended as it can dangerously lower oxygen levels if the cause isn't actually panic. Encourage slow, guided breaths.",
    ),
    FirstAidQuiz(
      questionEn: "What is the best way to remove a tick?",
      optionsEn: [
        "Burn it with a match",
        "Smother it in petroleum jelly",
        "Grasp it close to the skin with fine-tipped tweezers and pull straight up",
        "Twist it out with your fingers"
      ],
      answerIndex: 2,
      explanationEn: "Pulling straight up with fine tweezers ensures you remove the head without squeezing venom or bacteria into the bloodstream.",
    ),
    FirstAidQuiz(
      questionEn: "For an eye injury with a penetrating object, you should:",
      optionsEn: [
        "Pull the object out immediately",
        "Wash the eye out with water",
        "Stabilize the object with a cup and bandage both eyes",
        "Apply direct pressure to the eyeball"
      ],
      answerIndex: 2,
      explanationEn: "Never remove a penetrating object. Bandaging both eyes prevents the injured eye from moving while the patient looks around.",
    ),
    FirstAidQuiz(
      questionEn: "What does the 'S' in the acronym SAMPLE stand for during a patient assessment?",
      optionsEn: [
        "Signs and Symptoms",
        "Sleep habits",
        "Stress level",
        "Sugar levels"
      ],
      answerIndex: 0,
      explanationEn: "SAMPLE stands for Signs & Symptoms, Allergies, Medications, Past medical history, Last oral intake, and Events leading up to the injury.",
    ),
    FirstAidQuiz(
      questionEn: "When a person suffers an amputation (severed finger), how should you transport the body part?",
      optionsEn: [
        "Put it directly into a cup of ice water",
        "Wrap it in dry gauze, place in a waterproof bag, and place that bag on ice",
        "Wrap it in a warm, moist towel",
        "Leave it at the scene"
      ],
      answerIndex: 1,
      explanationEn: "Direct contact with ice can cause frostbite and destroy tissue. It must be kept cool but dry in a sealed bag.",
    ),
    FirstAidQuiz(
      questionEn: "What is the correct action for treating a jellyfish sting (in most non-tropical waters)?",
      optionsEn: [
        "Rinse with fresh tap water",
        "Rinse with vinegar and immerse in hot water",
        "Rub the area with sand",
        "Urinate on the sting"
      ],
      answerIndex: 1,
      explanationEn: "Vinegar deactivates the stingers (nematocysts), and hot water denatures the venom. Fresh water and rubbing cause them to fire more venom.",
    ),
    FirstAidQuiz(
      questionEn: "If an adult is unresponsive and breathing normally, place them in:",
      optionsEn: [
        "The recovery position (on their side)",
        "On their back with legs elevated",
        "Sitting upright",
        "Face down"
      ],
      answerIndex: 0,
      explanationEn: "The recovery position keeps the airway open and prevents them from choking on their own tongue or vomit.",
    ),
  ],
  // Set 4
  const [
    FirstAidQuiz(
      questionEn: "What is the main purpose of a splint?",
      optionsEn: [
        "To reduce pain by applying pressure",
        "To immobilize a broken bone or joint to prevent further injury",
        "To straighten out a broken bone",
        "To stop severe bleeding"
      ],
      answerIndex: 1,
      explanationEn: "A splint is used to keep an injured body part completely still, protecting nerves and blood vessels from the jagged edges of a broken bone.",
    ),
    FirstAidQuiz(
      questionEn: "How long should you check for breathing on an unconscious patient?",
      optionsEn: [
        "At least 30 seconds",
        "No more than 10 seconds",
        "Just a quick glance",
        "2 minutes"
      ],
      answerIndex: 1,
      explanationEn: "You should look, listen, and feel for normal breathing for no more than 10 seconds before deciding if CPR is needed.",
    ),
    FirstAidQuiz(
      questionEn: "A person has swallowed a poisonous household cleaner. You should first:",
      optionsEn: [
        "Make them vomit immediately",
        "Give them activated charcoal",
        "Call the Poison Control Center or emergency services",
        "Give them a glass of milk"
      ],
      answerIndex: 2,
      explanationEn: "Never induce vomiting unless instructed by a professional, as it can burn the throat again on the way up. Call professionals first.",
    ),
    FirstAidQuiz(
      questionEn: "When applying a bandage over a wound on a limb, you should check for:",
      optionsEn: [
        "Color, warmth, and feeling below the bandage (circulation)",
        "If the bandage matches their skin tone",
        "If the blood has soaked through completely",
        "If they can run on it"
      ],
      answerIndex: 0,
      explanationEn: "Always check capillary refill, warmth, and feeling to ensure the bandage isn't tied so tightly that it acts as a tourniquet.",
    ),
    FirstAidQuiz(
      questionEn: "In CPR, what does it mean to allow 'full chest recoil'?",
      optionsEn: [
        "Taking your hands completely off the chest between compressions",
        "Letting the chest return to its normal position between compressions",
        "Pushing down as hard as possible",
        "Giving breaths forcefully"
      ],
      answerIndex: 1,
      explanationEn: "Full recoil allows the heart chambers to refill with blood before the next compression pushes the blood out.",
    ),
    FirstAidQuiz(
      questionEn: "What is a tourniquet used for?",
      optionsEn: [
        "Minor scrapes and cuts",
        "Severe, life-threatening arterial bleeding on a limb",
        "Holding a splint in place",
        "Snake bites"
      ],
      answerIndex: 1,
      explanationEn: "A tourniquet completely stops blood flow to a limb and is only used as a last resort for severe, uncontrollable bleeding.",
    ),
    FirstAidQuiz(
      questionEn: "A victim has suffered a severe electrical burn. After ensuring the power is off, what do you do?",
      optionsEn: [
        "Cool the burn with ice",
        "Cover the burns with dry, sterile dressings and seek emergency help",
        "Apply an antibiotic ointment",
        "Give them water to drink"
      ],
      answerIndex: 1,
      explanationEn: "Electrical burns often have deep internal damage. Cover them with a clean, dry dressing to prevent infection and get them to a hospital.",
    ),
    FirstAidQuiz(
      questionEn: "What is frostbite?",
      optionsEn: [
        "A mild feeling of cold",
        "Freezing of the skin and underlying tissues",
        "A viral infection caused by cold weather",
        "A sudden drop in core body temperature"
      ],
      answerIndex: 1,
      explanationEn: "Frostbite occurs when tissues freeze. It causes the skin to become pale, hard, and numb. It should be rewarmed gently in warm water.",
    ),
    FirstAidQuiz(
      questionEn: "What is hypothermia?",
      optionsEn: [
        "A dangerously low core body temperature",
        "A high fever",
        "An allergic reaction to cold",
        "A skin condition"
      ],
      answerIndex: 0,
      explanationEn: "Hypothermia happens when the body loses heat faster than it can produce it, causing the core temperature to drop below 35°C (95°F).",
    ),
    FirstAidQuiz(
      questionEn: "If someone is experiencing heat exhaustion, you should:",
      optionsEn: [
        "Submerge them in an ice bath",
        "Move them to a cool place, loosen clothing, and give them sips of water",
        "Give them a hot coffee",
        "Make them exercise to sweat it out"
      ],
      answerIndex: 1,
      explanationEn: "Cooling them down gradually and rehydrating them is key. An ice bath is too extreme and can cause shock.",
    ),
  ],
  // Set 5
  const [
    FirstAidQuiz(
      questionEn: "What is the primary sign that a baby (infant) is choking?",
      optionsEn: [
        "Loud crying and coughing",
        "Inability to cry, cough, or breathe, and turning blue",
        "Vomiting milk",
        "Falling asleep suddenly"
      ],
      answerIndex: 1,
      explanationEn: "A choking baby cannot make sounds or breathe. If they are coughing loudly, their airway is only partially blocked.",
    ),
    FirstAidQuiz(
      questionEn: "How do you clear a severe airway obstruction in a conscious infant (under 1 year)?",
      optionsEn: [
        "Perform abdominal thrusts (Heimlich maneuver)",
        "Give 5 back slaps and 5 chest thrusts",
        "Shake the baby upside down",
        "Reach a finger blindly into the throat"
      ],
      answerIndex: 1,
      explanationEn: "Abdominal thrusts can damage an infant's internal organs. Instead, use a combination of back slaps and gentle chest thrusts.",
    ),
    FirstAidQuiz(
      questionEn: "What should you do if an adult choking victim becomes unconscious?",
      optionsEn: [
        "Lower them to the ground and begin CPR compressions",
        "Perform abdominal thrusts while they are on the floor",
        "Wait for the ambulance",
        "Pour water in their mouth"
      ],
      answerIndex: 0,
      explanationEn: "Once unconscious, abdominal thrusts are ineffective. Begin CPR. The chest compressions may help dislodge the object.",
    ),
    FirstAidQuiz(
      questionEn: "Which of these is a symptom of a concussion?",
      optionsEn: [
        "A twisted ankle",
        "Confusion, dizziness, and memory loss after a head bump",
        "A mild rash on the neck",
        "A sudden craving for sugar"
      ],
      answerIndex: 1,
      explanationEn: "A concussion is a mild traumatic brain injury affecting brain function. Rest and medical evaluation are necessary.",
    ),
    FirstAidQuiz(
      questionEn: "If a tooth is chipped but NOT completely knocked out, you should:",
      optionsEn: [
        "Pull the rest of the tooth out",
        "Rinse the mouth with warm water and apply a cold compress to the face",
        "Glue the chip back on with superglue",
        "Ignore it if it doesn't hurt"
      ],
      answerIndex: 1,
      explanationEn: "Rinsing cleans the area, and a cold compress reduces swelling. Save any pieces you can find and see a dentist.",
    ),
    FirstAidQuiz(
      questionEn: "What is the best immediate response for a chemical splash in the eye?",
      optionsEn: [
        "Rub the eye to produce tears",
        "Flush the eye continuously with running water for 15-20 minutes",
        "Cover the eye tightly and go to sleep",
        "Apply eye drops"
      ],
      answerIndex: 1,
      explanationEn: "Flushing the eye forcefully dilutes the chemical. Make sure the water runs away from the unaffected eye.",
    ),
    FirstAidQuiz(
      questionEn: "What is shock in a medical context?",
      optionsEn: [
        "Being emotionally surprised",
        "A life-threatening condition where organs don't get enough blood/oxygen",
        "An electric shock from an outlet",
        "A muscle cramp"
      ],
      answerIndex: 1,
      explanationEn: "Medical shock (hypoperfusion) means the body's tissues aren't receiving enough oxygenated blood, often due to severe bleeding or trauma.",
    ),
    FirstAidQuiz(
      questionEn: "How do you treat a victim in medical shock?",
      optionsEn: [
        "Make them walk around to pump blood",
        "Lay them flat, elevate their legs, and keep them warm",
        "Give them a large meal",
        "Give them a hot shower"
      ],
      answerIndex: 1,
      explanationEn: "Elevating legs returns blood to vital organs. Keeping them warm prevents heat loss. Do not give them food or drink.",
    ),
    FirstAidQuiz(
      questionEn: "Why do we use the 'Recovery Position'?",
      optionsEn: [
        "To make the person comfortable for sleeping",
        "To keep the airway clear and prevent aspiration (inhaling vomit)",
        "To stop them from moving their legs",
        "To reduce back pain"
      ],
      answerIndex: 1,
      explanationEn: "If an unconscious person vomits while on their back, they will choke. The recovery position allows fluids to drain out safely.",
    ),
    FirstAidQuiz(
      questionEn: "What should you carry in a basic first aid kit?",
      optionsEn: [
        "Bandages, antiseptic wipes, gauze, and medical tape",
        "A scalpel and sutures",
        "Prescription antibiotics for everyone",
        "An oxygen tank"
      ],
      answerIndex: 0,
      explanationEn: "A basic kit should contain items for cleaning and bandaging wounds. Surgical tools and prescriptions are only for trained professionals.",
    ),
  ],
];
