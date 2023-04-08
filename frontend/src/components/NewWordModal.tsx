import { Box, Button, Grid, Modal, TextField } from "@mui/material";
import React from "react";

const modalStyle = {
  position: "absolute" as "absolute",
  top: "50%",
  left: "50%",
  transform: "translate(-50%, -50%)",
  width: 400,
  bgcolor: "background.paper",
  border: "2px solid #000",
  boxShadow: 24,
  pt: 2,
  px: 4,
  pb: 3,
};
export default function NewWordModal({
  modalState,
  handleCloseModal,
  handleAddWord,
}: {
  modalState: { open: boolean; service: number };
  handleCloseModal: () => void;
  handleAddWord: (service: number, word: string) => void;
}) {
  const [newWord, setNewWord] = React.useState<string>("");

  return (
    <Modal open={modalState.open} onClose={handleCloseModal}>
      <Box sx={{ ...modalStyle, minWidth: 275, maxWidth: 350 }}>
        <h2 id="child-modal-title">Service {modalState.service + 1}</h2>
        <Box sx={{ p: 3 }}>
          <TextField
            fullWidth
            label="Add Word"
            variant="outlined"
            onChange={(e) => setNewWord(e.target.value)}
          />
        </Box>
        <Grid container justifyContent="right">
          <Button
            variant="contained"
            onClick={() => handleAddWord(modalState.service, newWord)}
          >
            Add Word
          </Button>
        </Grid>
      </Box>
    </Modal>
  );
}
