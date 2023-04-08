import { Alert, AlertColor, Snackbar } from "@mui/material";

export default function InfoSnackbar({
  snackBarState,
  handleCloseSnackbar,
}: {
  snackBarState: { open: boolean; severity: string; message: string };
  handleCloseSnackbar: () => void;
}) {
  return (
    <Snackbar
      open={snackBarState.open}
      autoHideDuration={6000}
      onClose={handleCloseSnackbar}
      anchorOrigin={{ vertical: "top", horizontal: "right" }}
    >
      <Alert
        onClose={handleCloseSnackbar}
        severity={snackBarState.severity as AlertColor}
        sx={{ width: "100%" }}
      >
        {snackBarState.message}
      </Alert>
    </Snackbar>
  );
}
