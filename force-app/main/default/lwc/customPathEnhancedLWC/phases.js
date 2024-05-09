const ALL_PHASES = [
  {
    label: "DISCOVER",
    class: "discoverClass",
    cursor: "discoverCursor1",
    isEmpty: false
  },
  {
    label: "Opportunity Milestone",
    class: "opportunityClass",
    cursor: "discoverCursor2",
    isEmpty: false
  },
  {
    label: "DEFINE",
    class: "defineClass",
    cursor: "discoverCursor3",
    isEmpty: false
  },
  {
    label: "Business Case Ambition",
    class: "bcaClass",
    cursor: "discoverCursor4",
    isEmpty: false
  },
  {
    label: "DESIGN",
    class: "designClass",
    cursor: "discoverCursor5",
    isEmpty: false
  },
  {
    label: "Business Case Validation",
    class: "bcvClass",
    cursor: "discoverCursor6",
    isEmpty: false
  },
  {
    label: "DEVELOP",
    class: "developClass",
    cursor: "discoverCursor7",
    isEmpty: false
  },
  {
    label: "Commercial Milestone",
    class: "commercialClass",
    cursor: "discoverCursor8",
    isEmpty: false
  },
  {
    label: "DEPLOY",
    class: "deployClass",
    cursor: "discoverCursor9",
    isEmpty: false
  },
  {
    label: "Production Milestone",
    class: "productionClass",
    cursor: "discoverCursor10",
    isEmpty: false
  },
  {
    label: "DIAGNOSE",
    class: "diagnoseClass",
    cursor: "discoverCursor11",
    isEmpty: false
  }
];

const PHASES_WITHOUT_DISCOVER = [
  {
    label: "DEFINE",
    class: "defineClass",
    cursor: "discoverCursor3",
    isEmpty: false
  },
  {
    label: "Business Case Ambition",
    class: "bcaClass",
    cursor: "discoverCursor4",
    isEmpty: false
  },
  {
    label: "DESIGN",
    class: "designClass",
    cursor: "discoverCursor5",
    isEmpty: false
  },
  {
    label: "Business Case Validation",
    class: "bcvClass",
    cursor: "discoverCursor6",
    isEmpty: false
  },
  {
    label: "DEVELOP",
    class: "developClass",
    cursor: "discoverCursor7",
    isEmpty: false
  },
  {
    label: "Commercial Milestone",
    class: "commercialClass",
    cursor: "discoverCursor8",
    isEmpty: false
  },
  {
    label: "DEPLOY",
    class: "deployClass",
    cursor: "discoverCursor9",
    isEmpty: false
  },
  {
    label: "Production Milestone",
    class: "productionClass",
    cursor: "discoverCursor10",
    isEmpty: false
  },
  {
    label: "DIAGNOSE",
    class: "diagnoseClass",
    cursor: "discoverCursor11",
    isEmpty: false
  }
];

const PHASES_WITHOUT_DEVELOP = [
  {
    label: "DISCOVER",
    class: "discoverClass",
    cursor: "discoverCursor1",
    isEmpty: false
  },
  {
    label: "Opportunity Milestone",
    class: "opportunityClass",
    cursor: "discoverCursor2",
    isEmpty: false
  },
  {
    label: "DEFINE",
    class: "defineClass",
    cursor: "discoverCursor3",
    isEmpty: false
  },
  {
    label: "Business Case Ambition",
    class: "bcaClass",
    cursor: "discoverCursor4",
    isEmpty: false
  },
  {
    label: "DESIGN",
    class: "designClass",
    cursor: "discoverCursor5",
    isEmpty: false
  },
  {
    label: "Business Case Validation",
    class: "bcvClass",
    cursor: "discoverCursor6",
    isEmpty: false
  },
  {
    label: "DEPLOY",
    class: "deployClass",
    cursor: "discoverCursor9",
    isEmpty: false
  },
  {
    label: "Production Milestone",
    class: "productionClass",
    cursor: "discoverCursor10",
    isEmpty: false
  },
  {
    label: "DIAGNOSE",
    class: "diagnoseClass",
    cursor: "discoverCursor11",
    isEmpty: false
  }
];

const PHASES_WITHOUT_DISCOVER_AND_DEVELOP = [
  {
    label: "DEFINE",
    class: "defineClass",
    cursor: "discoverCursor3",
    isEmpty: false
  },
  {
    label: "Business Case Ambition",
    class: "bcaClass",
    cursor: "discoverCursor4",
    isEmpty: false
  },
  {
    label: "DESIGN",
    class: "designClass",
    cursor: "discoverCursor5",
    isEmpty: false
  },
  {
    label: "Business Case Validation",
    class: "bcvClass",
    cursor: "discoverCursor6",
    isEmpty: false
  },
  {
    label: "DEPLOY",
    class: "deployClass",
    cursor: "discoverCursor9",
    isEmpty: false
  },
  {
    label: "Production Milestone",
    class: "productionClass",
    cursor: "discoverCursor10",
    isEmpty: false
  },
  {
    label: "DIAGNOSE",
    class: "diagnoseClass",
    cursor: "discoverCursor11",
    isEmpty: false
  }
];

const PHASES_DEFINE_DEPLOY_AND_DIAGNOSE = [
  {
    label: "DEFINE",
    class: "defineClass",
    cursor: "discoverCursor3",
    isEmpty: false
  },
  {
    label: "Business Case Ambition",
    class: "bcaClass",
    cursor: "discoverCursor4",
    isEmpty: false
  },
  {
    label: "DEPLOY",
    class: "deployClass",
    cursor: "discoverCursor9",
    isEmpty: false
  },
  {
    label: "Production Milestone",
    class: "productionClass",
    cursor: "discoverCursor10",
    isEmpty: false
  },
  {
    label: "DIAGNOSE",
    class: "diagnoseClass",
    cursor: "discoverCursor11",
    isEmpty: false
  }
];

const PHASES_DEFINE_AND_DEVELOP_AND_DIAGNOSE = [
  {
    label: "DEFINE",
    class: "defineClass",
    cursor: "discoverCursor3",
    isEmpty: false
  },
  {
    label: "Business Case Ambition",
    class: "bcaClass",
    cursor: "discoverCursor4",
    isEmpty: false
  },
  {
    label: "DEVELOP",
    class: "developClass",
    cursor: "discoverCursor7",
    isEmpty: false
  },
  {
    label: "Commercial Milestone",
    class: "commercialClass",
    cursor: "discoverCursor8",
    isEmpty: false
  },
  {
    label: "DIAGNOSE",
    class: "diagnoseClass",
    cursor: "discoverCursor11",
    isEmpty: false
  }
];

const PHASES_DEFINE_AND_DEVELOP_AND_DEPLOY_AND_DIAGNOSE = [
  {
    label: "DEFINE",
    class: "defineClass",
    cursor: "discoverCursor3",
    isEmpty: false
  },
  {
    label: "Business Case Ambition",
    class: "bcaClass",
    cursor: "discoverCursor4",
    isEmpty: false
  },
  {
    label: "DEVELOP",
    class: "developClass",
    cursor: "discoverCursor7",
    isEmpty: false
  },
  {
    label: "Commercial Milestone",
    class: "commercialClass",
    cursor: "discoverCursor8",
    isEmpty: false
  },
  {
    label: "DEPLOY",
    class: "deployClass",
    cursor: "discoverCursor9",
    isEmpty: false
  },
  {
    label: "Production Milestone",
    class: "productionClass",
    cursor: "discoverCursor10",
    isEmpty: false
  },
  {
    label: "DIAGNOSE",
    class: "diagnoseClass",
    cursor: "discoverCursor11",
    isEmpty: false
  }
];

const PHASES_DEFINE_AND_DIAGNOSE = [
  {
    label: "DEFINE",
    class: "defineClass",
    cursor: "discoverCursor3",
    isEmpty: false
  },
  {
    label: "Business Case Ambition",
    class: "bcaClass",
    cursor: "discoverCursor4",
    isEmpty: false
  },
  {
    label: "DIAGNOSE",
    class: "diagnoseClass",
    cursor: "discoverCursor11",
    isEmpty: false
  }
];

export {
  ALL_PHASES,
  PHASES_DEFINE_AND_DIAGNOSE,
  PHASES_DEFINE_DEPLOY_AND_DIAGNOSE,
  PHASES_DEFINE_AND_DEVELOP_AND_DIAGNOSE,
  PHASES_DEFINE_AND_DEVELOP_AND_DEPLOY_AND_DIAGNOSE,
  PHASES_WITHOUT_DEVELOP,
  PHASES_WITHOUT_DISCOVER,
  PHASES_WITHOUT_DISCOVER_AND_DEVELOP
};