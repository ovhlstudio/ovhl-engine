#!/bin/bash
# ====================================================================
# MASTER EXECUTION GUIDE
# Complete workflow for OVHL V1.0.0 Enhancement
# ====================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     OVHL ENGINE V1.0.0 - ENHANCEMENT IMPLEMENTATION        ║"
echo "║     Smart Bash Scripting Workflow                          ║"
echo "║     Branch: dev | Commit: 1b9729f                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo -e "${CYAN}📋 EXECUTION PLAN:${NC}"
echo ""
echo "PHASE 1: Fix Issues"
echo "  1️⃣  Fix ClientRuntime (remove bloat)"
echo "  2️⃣  Verify ServerRuntime (minimal edits)"
echo ""
echo "PHASE 2: Adapter Pattern"
echo "  3️⃣  Create Permission Adapters (Internal + HDAdmin)"
echo "  4️⃣  Refactor PermissionCore (loader)"
echo "  5️⃣  Create Navbar Adapters (TopbarPlus + Internal)"
echo "  6️⃣  Refactor UIManager (loader)"
echo "  7️⃣  Update EngineConfig.lua (adapter selectors)"
echo ""
echo "PHASE 3: Testing"
echo "  8️⃣  Create test structure (Unit/Integration/E2E)"
echo "  9️⃣  Create PrototypeShop module"
echo ""
echo "PLAYTEST: Validation"
echo "  🎮 Test in Roblox Studio"
echo "  🧪 Verify all systems work"
echo ""

echo -e "${YELLOW}⚠️  IMPORTANT:${NC}"
echo "  • Each script will backup existing files"
echo "  • Scripts validate before and after changes"
echo "  • All reports show exact changes made"
echo "  • No manual editing needed!"
echo ""

echo -e "${BLUE}📁 SCRIPT LOCATIONS:${NC}"
echo "  All scripts in: ./scripts/"
echo "  Backups in: ./lokal/backups/[task-timestamp]/"
echo "  New files: ./src/"
echo ""

read -p "Ready to start? (yes/no): " READY

if [ "$READY" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                  PHASE 1: FIX ISSUES                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo -e "${CYAN}1️⃣  Fix ClientRuntime.client.lua${NC}"
echo "  • Remove double :Initialize()"
echo "  • Remove hardcoded F2 keybind"
echo "  • Remove MinimalModule test logic"
echo "  • Add proper headers/footers"
echo ""

read -p "Run Phase 1.1? (yes/no): " RUN_1_1

if [ "$RUN_1_1" = "yes" ]; then
    bash ./scripts/phase-1.1-fix-clientruntime.sh
    echo ""
    read -p "Press enter to continue..."
fi

echo ""
echo -e "${CYAN}2️⃣  Verify ServerRuntime.server.lua${NC}"
echo "  • Verify correct structure"
echo "  • Add headers/footers"
echo "  • Check 4-Phase lifecycle"
echo ""

read -p "Run Phase 1.2? (yes/no): " RUN_1_2

if [ "$RUN_1_2" = "yes" ]; then
    bash ./scripts/phase-1.2-fix-serverruntime.sh
    echo ""
    read -p "Press enter to continue..."
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              ⚠️  PLAYTEST CHECK (PHASE 1)                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo -e "${YELLOW}IMPORTANT: Test before continuing!${NC}"
echo ""
echo "1️⃣  Open Roblox Studio"
echo "2️⃣  Run game (Play)"
echo "3️⃣  Check console output:"
echo "    ✓ Should see: 🎊 CLIENT BOOT COMPLETE"
echo "    ✓ Should see: 🎊 SERVER BOOT COMPLETE"
echo "    ✓ No errors!"
echo ""
echo "4️⃣  If errors:"
echo "    → Backup restores available in ./lokal/backups/"
echo "    → Run: bash ./scripts/restore-backup.sh"
echo ""

read -p "Playtest OK? Continue to Phase 2? (yes/no): " PLAYTEST_OK

if [ "$PLAYTEST_OK" != "yes" ]; then
    echo "Fix errors first, then re-run scripts."
    exit 1
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║            PHASE 2: ADAPTER PATTERN                        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo -e "${CYAN}3️⃣  Create Permission Adapters${NC}"
echo "  • InternalAdapter.lua (our permission service)"
echo "  • HDAdminAdapter.lua (bridge to HD Admin)"
echo "  Location: ./src/ReplicatedStorage/OVHL/Systems/Adapters/Permission/"
echo ""

read -p "Run Phase 2.1? (yes/no): " RUN_2_1

if [ "$RUN_2_1" = "yes" ]; then
    bash ./scripts/phase-2.1-permission-adapters.sh
    echo ""
    echo "📝 NEXT MANUAL STEP:"
    echo "   • Copy refactored PermissionCore.lua from artifacts"
    echo "   • Replace: ./src/ReplicatedStorage/OVHL/Systems/Security/PermissionCore.lua"
    echo ""
    read -p "Done copying PermissionCore? (yes/no): " PERM_COPY
fi

echo ""
echo -e "${CYAN}4️⃣  Create Navbar Adapters${NC}"
echo "  • TopbarPlusAdapter.lua (bridge to TopbarPlus V3)"
echo "  • InternalAdapter.lua (native Fusion UI fallback)"
echo "  Location: ./src/ReplicatedStorage/OVHL/Systems/Adapters/Navbar/"
echo ""

read -p "Run Phase 2.2? (yes/no): " RUN_2_2

if [ "$RUN_2_2" = "yes" ]; then
    bash ./scripts/phase-2.2-navbar-adapters.sh
    echo ""
    echo "📝 NEXT MANUAL STEPS:"
    echo "   • Refactor UIManager.lua (loader pattern)"
    echo "   • Update EngineConfig.lua:"
    echo "     Adapters = {"
    echo "       Permission = 'HDAdminAdapter',"
    echo "       Navbar = 'TopbarPlusAdapter'"
    echo "     }"
    echo ""
    read -p "Done manual steps? (yes/no): " CONFIG_DONE
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║            PHASE 3: TEST MODULE & VALIDATION               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo -e "${CYAN}5️⃣  Create Test Structure${NC}"
echo "  tests/"
echo "  ├── Unit/"
echo "  ├── Integration/"
echo "  ├── E2E/"
echo "  └── Prototype/"
echo ""

read -p "Ready to continue? (yes/no): " READY_PHASE3

if [ "$READY_PHASE3" != "yes" ]; then
    echo "Paused. You can continue later with next script."
    exit 0
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                   ✅ ALL READY!                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo -e "${GREEN}STATUS:${NC}"
echo "  ✅ Phase 1: Fix Issues (ClientRuntime + ServerRuntime)"
echo "  ✅ Phase 2: Adapter Pattern (Permission + Navbar)"
echo "  ✅ Ready for Phase 3: Testing"
echo ""

echo -e "${YELLOW}NEXT:${NC}"
echo "  Run: bash ./scripts/phase-3-test-structure.sh"
echo ""

echo -e "${CYAN}📁 PROJECT STRUCTURE:${NC}"
echo "  ./src/ReplicatedStorage/OVHL/Systems/"
echo "  └── Adapters/"
echo "      ├── Permission/"
echo "      │   ├── InternalAdapter.lua ✅"
echo "      │   └── HDAdminAdapter.lua ✅"
echo "      └── Navbar/"
echo "          ├── TopbarPlusAdapter.lua ✅"
echo "          └── InternalAdapter.lua ✅"
echo ""

echo -e "${CYAN}📋 BACKUPS CREATED:${NC}"
echo "  ./lokal/backups/"
echo "  ├── fix-clientruntime-[timestamp]/"
echo "  ├── fix-serverruntime-[timestamp]/"
echo "  ├── permission-adapters-[timestamp]/"
echo "  └── navbar-adapters-[timestamp]/"
echo ""

echo "Done! Ready for next phase. 🚀"