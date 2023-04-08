import React, { useCallback, useEffect, useMemo } from "react";
import "./App.css";
import {
  AlertColor,
  Button,
  Card,
  CardActions,
  CardContent,
  Container,
  Grid,
  Typography,
} from "@mui/material";
import axios from "axios";
import NewWordModal from "./components/NewWordModal";
import InfoSnackbar from "./components/InfoSnackbar";

type RandomWordResponse = {
  data: {
    id: string;
    word: string;
  };
};

function App() {
  const services = useMemo(
    () => process.env.REACT_APP_SERVICES_URL?.split(";") || [],
    []
  );

  const [modalState, setModalState] = React.useState({
    open: false,
    service: 0,
  });
  const handleOpenModal = (service: number) =>
    setModalState({ open: true, service });
  const handleCloseModal = () => setModalState({ open: false, service: 0 });

  const [words, setWords] = React.useState<string[]>([]);

  const [snackBarState, setSnackBarState] = React.useState({
    open: false,
    message: "",
    severity: "success",
  });
  const handleOpenSnackbar = (message: string, severity: AlertColor) =>
    setSnackBarState({ open: true, message, severity });
  const handleCloseSnackbar = () =>
    setSnackBarState({ open: false, message: "", severity: "success" });

  const handleAddWord = (service: number, word: string) => {
    axios
      .post(`${services[service]}/word`, { word })
      .then(() => {
        handleOpenSnackbar(
          `Word added successfully to service ${service + 1}`,
          "success"
        );

        handleCloseModal();
      })
      .catch((err) => {
        handleOpenSnackbar(
          err?.response?.status === 409
            ? `Word already exists on service ${service + 1}`
            : `Error adding word to service ${service + 1}, check the console`,
          "error"
        );

        console.error(err);
      });
  };

  const getWords = useCallback(() => {
    const promises = services.map((service) => {
      return axios.post<RandomWordResponse>(`${service}/word/random`);
    });
    Promise.all(promises)
      .then((res) => {
        setWords(res.map((value) => value.data.data.word));
      })
      .catch((err) => {
        handleOpenSnackbar(
          `Error getting words from services, check the console`,
          "error"
        );

        console.error(err);
      });
  }, [services]);

  useEffect(() => getWords(), [services, getWords]);

  return (
    <Container>
      <NewWordModal
        handleAddWord={handleAddWord}
        handleCloseModal={handleCloseModal}
        modalState={modalState}
      />
      <InfoSnackbar
        handleCloseSnackbar={handleCloseSnackbar}
        snackBarState={snackBarState}
      />
      <Grid
        container
        justifyContent="center"
        alignItems="center"
        minHeight="95vh"
        spacing="20"
      >
        {services.map((_, key) => (
          <Grid key={key} item>
            <Card sx={{ minWidth: 275, maxWidth: 350 }}>
              <CardContent>
                <Typography
                  sx={{ fontSize: 14 }}
                  color="text.secondary"
                  gutterBottom
                >
                  Service {key + 1}
                </Typography>
                <Typography variant="h5" component="div">
                  {words[key]}
                </Typography>
              </CardContent>
              <CardActions>
                <Button size="small" onClick={() => handleOpenModal(key)}>
                  Add Word
                </Button>
              </CardActions>
            </Card>
          </Grid>
        ))}
      </Grid>
      <Grid container justifyContent="center">
        <Button variant="contained" onClick={getWords}>
          Refresh Words
        </Button>
      </Grid>
    </Container>
  );
}

export default App;
